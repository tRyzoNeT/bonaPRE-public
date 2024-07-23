# Vérifie si le package bonaPRE-CONF-PUBLIC est chargé, sinon affiche une erreur.
if { [catch { package require bonaPRE-CONF-PUBLIC 1.1 }] } {
  die "${::bonaPRE::VAR(release)} modTCL : le fichier configuration.tcl doit être chargé avant mysql.tcl"
  return
}

# Crée un espace de nom pour les procédures MySQL
namespace eval ::bonaPRE::MySQL {}

# Gère les erreurs spécifiques de MySQL et retourne un message approprié.
proc ::bonaPRE::MySQL::handleError {mysqlError} {
  # Vérifie si l'erreur contient "Access denied"
  if { [string match "*Access*denied*" $mysqlError] } {
    return "Erreur Tcl \[::${::bonaPRE::VAR(release)}::MySQL\] : vérifier les informations MySQL."
  } else {
    return "Erreur Tcl \[::${::bonaPRE::VAR(release)}::MySQL\] : erreur SQL fatale \[::mysql::connect\] : $mysqlError"
  }
}

# Établit une connexion à la base de données MySQL avec les paramètres spécifiés.
proc ::bonaPRE::MySQL::connect {} {
  if { [catch {
    # Établit la connexion à la base de données MySQL
    set handle                  [::mysql::connect -multistatement 1 -ssl "${::bonaPRE::mysql_(mode_ssl)}" -host "${::bonaPRE::mysql_(host)}"  -user "${::bonaPRE::mysql_(user)}" -password "${::bonaPRE::mysql_(password)}"  -db       "${::bonaPRE::mysql_(db)}"];
  } MYSQL_ERR] } {
    # En cas d'erreur de connexion, gère l'erreur et retourne le message approprié.
    set messageError [::bonaPRE::MySQL::handleError $MYSQL_ERR]
    putlog $messageError
    return -error $messageError
  }
  return $handle
}

# Assure que la connexion à MySQL reste active en utilisant un utimer pour le refresh.
proc ::bonaPRE::MySQL::KeepAlive {} {
  if { [::bonaPRE::MySQL::isActive] } {
    # Si la connexion est active, affiche un message de confirmation.
    putlog "Tcl exec \[::${::bonaPRE::VAR(release)}::MySQL\] : Connexion active. 'KeepAlive' \[${::bonaPRE::mysql_(handle)}\]"
  } else {
    set ::bonaPRE::mysql_(handle) [::bonaPRE::MySQL::getHandle]
    # Si la connexion est inactive, affiche un message d'erreur.
    putlog "Tcl exec \[::${::bonaPRE::VAR(release)}::MySQL\] : Connexion inactive. 'KeepAlive' \[${::bonaPRE::mysql_(handle)}\], reconnexion.."
  }
  utimer ${::bonaPRE::mysql_(conrefresh)} [list ::bonaPRE::MySQL::KeepAlive] 1 SQLKeepAlive
  return $::bonaPRE::mysql_(handle)
}

# Vérifie si la connexion à MySQL est active.
proc ::bonaPRE::MySQL::isActive {} {
  if { [info exists ::bonaPRE::mysql_(handle)] && \
       [::mysql::state ${::bonaPRE::mysql_(handle)} -numeric]!="1" && \
       [::mysql::state ${::bonaPRE::mysql_(handle)} -numeric]!="0" } {
    return 1
  }
  return 0
}

# Renvoie le handle de la connexion à MySQL.
proc ::bonaPRE::MySQL::getHandle {} {
  if {[::bonaPRE::MySQL::isActive]} { 
      return ${::bonaPRE::mysql_(handle)};
  }
  if {[catch { set ::bonaPRE::mysql_(handle) [::bonaPRE::MySQL::connect] } mysqlError]} {
    putlog "Erreur de connexion MySQL : $mysqlError"; return 0;
    die "Erreur de connexion MySQL : $mysqlError"; return 0;
  } else { return ${::bonaPRE::mysql_(handle)}; }
}

# Démarre le mécanisme de KeepAlive pour maintenir la connexion MySQL active.
catch { timer ${::bonaPRE::mysql_(conrefresh)} [list ::bonaPRE::MySQL::KeepAlive] 1 SQLKeepAlive }

# Les fonctions core
proc ::bonaPRE::MySQL::sel { handle query {args {}} } {
  if { [catch { set result [::mysql::sel [::bonaPRE::MySQL::getHandle] $query $args] } mysqlError] } {
    set messageError [::bonaPRE::MySQL::handleError $mysqlError]
    putlog $messageError
    return -error $messageError
  }
  return $result
}

proc ::bonaPRE::MySQL::exec { handle query {args {}} } {
  if { [catch { set result [::mysql::exec [::bonaPRE::MySQL::getHandle] $query $args] } mysqlError] } {
    set messageError [::bonaPRE::MySQL::handleError $mysqlError]
    putlog $messageError
    return -error $messageError
  }
  return $result
}

proc ::bonaPRE::MySQL::insertid { handle } {
  if { [catch { set result [::mysql::insertid [::bonaPRE::MySQL::getHandle]] } mysqlError] } {
    set messageError [::bonaPRE::MySQL::handleError $mysqlError]
    putlog $messageError
    return -error $messageError
  }
  return $result
}
# Les fonctions dédiées à la gestion des requêtes MySQL
proc ::bonaPRE::MySQL::addrelease { query } {
  if { [catch { set result [::mysql::exec [::bonaPRE::MySQL::getHandle] $query] } mysqlError] } {
    set messageError [::bonaPRE::MySQL::handleError $mysqlError]
    putlog $messageError
    return -error $messageError
  }
  return $result
}

# Indique la version du package fournie.
package provide bonaPRE-SQL 1.1
