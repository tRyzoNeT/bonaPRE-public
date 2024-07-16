# Vérifie si le package bonaPRE-CONF-PUBLiC est chargé, sinon affiche une erreur.
if { [catch { package require bonaPRE-CONF-PUBLiC 1.1 }] } {
  die "${::bonaPRE::VAR(release)} modTCL * le fichier configuration.tcl doit être chargé avant mysql.tcl"
  return
}

namespace eval ::bonaPRE::MySQL {}

# Gère les erreurs spécifiques de MySQL et retourne un message approprié.
proc ::bonaPRE::MySQL::handleError {mysqlError} {
  if { [string match "*Access*denied*" $mysqlError] } {
    return "Tcl error [::${::bonaPRE::VAR(release)}::MySQL]: vérifier les informations MySQL."
  } else {
    return "Tcl error [::${::bonaPRE::VAR(release)}::MySQL]: SQL FATAL [::mysql::connect]: $mysqlError"
  }
}

# Établit une connexion à la base de données MySQL avec les paramètres spécifiés.
proc ::bonaPRE::MySQL::connect {} {
  if { [catch {
    set handle [::mysql::connect                                                \
      -multistatement           1                                               \
      -ssl                      "${::bonaPRE::mysql_(mode_ssl)}"                \
      -host                     "${::bonaPRE::mysql_(host)}"                    \
      -user                     "${::bonaPRE::mysql_(user)}"                    \
      -password                 "${::bonaPRE::mysql_(password)}"                \
      -db                       "${::bonaPRE::mysql_(db)}"
    ]
  } MYSQL_ERR] } {
    unset ::bonaPRE::mysql_(handle)
    # En cas d'erreur de connexion, gère l'erreur et retourne le message approprié.
    set messageError            [::bonaPRE::MySQL::handleError $MYSQL_ERR]
    putlog $messageError
    return -error $messageError
  }
  return -ok $handle
}

# Établit une connexion à MySQL et gère les erreurs de manière loggée.
proc ::bonaPRE::MySQL::connectAndLog {{reconnect 0}} {
  if { [catch { 
    set handle                  [::bonaPRE::MySQL::connect]
   } MYSQL_ERR] } {
    set messageError            [::bonaPRE::MySQL::handleError $MYSQL_ERR]
    putlog $messageError
    return -error $messageError
  }
  if {$reconnect} {
    putlog  [format "Tcl exec \[::%s::MySQL\]: reconnexion avec succès. 'KeepAlive' \[%s\]" \
                      ${::bonaPRE::VAR(release)}                                \
                      $handle                                                   \
            ];
  } else {
    putlog  [format "Tcl exec \[::%s::MySQL]: Connexion avec succès. 'KeepAlive' \[%s\]" \
                      ${::bonaPRE::VAR(release)}                                \
                      $handle                                                   \
            ];
  }
  return $handle
}

# Assure que la connexion à MySQL reste active en utilisant un utimer pour le refresh.
proc ::bonaPRE::MySQL::KeepAlive {} {
  utimer ${::bonaPRE::mysql_(conrefresh)} [list ::bonaPRE::MySQL::KeepAlive]
  if { ![info exists ::bonaPRE::mysql_(handle)] } {
    # Si aucune poignée de connexion n'existe, établit une nouvelle connexion.
    set ::bonaPRE::mysql_(handle) [::bonaPRE::MySQL::connectAndLog]
  } elseif {  ![::mysql::ping $::bonaPRE::mysql_(handle)] } {
    # Si la connexion existe mais n'est pas active, tente de reconnecter.
    set ::bonaPRE::mysql_(handle) [::bonaPRE::MySQL::connectAndLog 1]
  } else {
    # Si la connexion est active, affiche un message de confirmation.
    putlog "Tcl exec [::${::bonaPRE::VAR(release)}::MySQL]: Connexion active. 'KeepAlive' [${::bonaPRE::mysql_(handle)}]"
  }
  return -ok $::bonaPRE::mysql_(handle)
}

# Démarre le mécanisme de KeepAlive pour maintenir la connexion MySQL active.
::bonaPRE::MySQL::KeepAlive 

# Indique la version du package fournie.
package provide bonaPRE-SQL 1.1

# Affiche un message de confirmation pour le chargement du module MySQL_SSL.
putlog "Tcl load \[::${::bonaPRE::VAR(release)}::MySQL_SSL\]: modTCL chargé."