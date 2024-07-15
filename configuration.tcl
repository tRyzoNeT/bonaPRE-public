namespace eval ::bonaPRE {

  # Définition des variables générales du bot
  array set VAR [list
    "release"                   "bonaPRE"                                        # Nom de la release
    "desc"                      "*TCL PREBOT*"                                   # Description du bot
    "version"                   "v1.1P"                                          # Version du bot
    "dev"                       "og"                                             # Développeur
    "git"                       "https://github.com/tRyzoNeT/bonaPRE-public"     # URL du dépôt Git
  ]

  # Configuration de la connexion MySQL
  array set mysql_ [list
    "user"                      "mysql_user"                                    # Utilisateur MySQL
    "password"                  "mysql_pass"                                    # Mot de passe MySQL
    "host"                      "mysql_host-ip"                                 # Hôte MySQL
    "mode_ssl"                  0                                               # Utilisation du SSL (0 = non, 1 = oui)
    "db"                        "mysql_db"                                      # Base de données
    "dbmain"                    "MAIN"                                          # Base de données principale
    "dburl"                     "XTRA_URL"                                      # Base de données pour les URL supplémentaires
    "dbnuke"                    "NUKE"                                          # Base de données pour les releases nuke
    "conrefresh"                "2000"                                          # Intervalle de rafraîchissement de la connexion
  ]

  # URL pour les recherches de séries et films
  array set url_ [list
    "tvmaze"                    "https://www.tvmaze.com/shows/"                 # URL pour TVMaze
    "imdb"                      "https://www.imdb.com/title/"                   # URL pour IMDb
  ]

  # Configuration des canaux IRC
  array set chan_ [list
    "add"                       "#bonaPRE-public"                               # Canal pour les ajouts
    "pred"                      "#bonaPRE-public"                               # Canal pour les prédictions
    "nuke"                      "#bonaPRE-public"                               # Canal pour les nuke
    "stats"                     "#bonaPRE-public"                               # Canal pour les statistiques
    "spam"                      "#bonaPRE-public"                               # Canal pour les spams
    "filtre"                    "#bonaPRE-public"                               # Canal pour les filtres
  ]

  # Configuration des champs de la base de données
  array set db_ [list
    "id"                        "id"                                            # Identifiant
    "rlsname"                   "rlsname"                                       # Nom de la release
    "group"                     "group"                                         # Groupe
    "section"                   "section"                                       # Section
    "datetime"                  "datetime"                                      # Date et heure
    "lastupdated"               "lastupdated"                                   # Dernière mise à jour
    "status"                    "status"                                        # Statut
    "files"                     "files"                                         # Fichiers
    "size"                      "size"                                          # Taille
  ]

  # Configuration des champs pour les releases nuke
  array set nuke_ [list
    "id"                        "id"                                            # Identifiant
    "rlsname"                   "rlsname"                                       # Nom de la release
    "group"                     "group"                                         # Groupe
    "datetime"                  "datetime"                                      # Date et heure
    "nuke"                      "nuke"                                          # Statut du nuke
    "raison"                    "raison"                                        # Raison du nuke
    "nukenet"                   "nukenet"                                       # Réseau de nuke
  ]

  # Configuration des champs pour les suppressions
  array set del_ [list
    "id"                        "id"                                            # Identifiant
    "releaseName"               "releaseName"                                   # Nom de la release
    "groupName"                 "groupName"                                     # Nom du groupe
    "datetime"                  "datetime"                                      # Date et heure
    "typeName"                  "typeName"                                      # Type
    "reasonMessage"             "reasonMessage"                                 # Message de la raison
    "delNetName"                "delNetName"                                    # Réseau de suppression
  ]

  # Configuration des champs pour les URL de la base de données
  array set dburl_ [list
    "id"                        "id"                                            # Identifiant
    "rlsname"                   "rlsname"                                       # Nom de la release
    "group"                     "group"                                         # Groupe
    "lastupdated"               "lastupdated"                                   # Dernière mise à jour
    "addurl"                    "addurl"                                        # URL ajoutée
    "imdb"                      "imdb"                                          # URL IMDb
    "tvmaze"                    "tvmaze"                                        # URL TVMaze
  ]

  # Définition des flags
  ################################################################################
  setudef flag bpadd
  setudef flag bpdb
  setudef flag bpecho
  setudef flag bpfiltre
  setudef flag bpnuke
  setudef flag bpdel
  setudef flag bpsearch
  setudef flag bpstats
  setudef flag bpurl

  # Vérification de la disponibilité du package mysqltcl, et arrêt du script en cas d'absence
  ################################################################################
  if { [catch { package require mysqltcl }] } {
    die "\[configuration.tcl - erreur\] le script nécessite le package mysqltcl."
    return
  }

  # Fournir le package bonaPRE-CONF-PUBLiC
  package provide bonaPRE-CONF-PUBLiC 1.1

  # Message de log à la chargement du module
  putlog [format "Tcl load \[::%s::%s::CONFiG\]: modTCL chargé." \
    ${::bonaPRE::VAR(release)} \
    ${::bonaPRE::VAR(version)}]

  ############################### FIN DU SCRIPT ##################################
}
