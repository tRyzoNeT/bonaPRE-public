namespace eval ::bonaPRE {

  # Définition des variables générales du bot
  array set VAR       [list                                                     \
    "release"                   "bonaPRE"                                       \
    "desc"                      "*TCL PREBOT*"                                  \
    "version"                   "v1.1P"                                         \
    "dev"                       "og"                                            \
    "git"                       "https://github.com/tRyzoNeT/bonaPRE-public"    \
  ]

  # Configuration de la connexion MySQL
  array set mysql_    [list                                                     \
    "user"                      "mysql_user"                                    \
    "password"                  "mysql_pass"                                    \
    "host"                      "mysql_host-ip"                                 \
    "mode_ssl"                  0                                               \
    "db"                        "mysql_db"                                      \
    "dbmain"                    "MAIN"                                          \
    "dburl"                     "XTRA_URL"                                      \
    "dbnuke"                    "NUKE"                                          \
    "conrefresh"                "2000"                                          \
  ]

  # URL pour les recherches de séries et films
  array set url_    [list                                                       \
    "tvmaze"                    "https://www.tvmaze.com/shows/"                 \
    "imdb"                      "https://www.imdb.com/title/"                   \
  ]

  # Configuration des canaux IRC
  array set chan_   [list                                                       \
    "add"                       "#bonaPRE-public"                               \
    "pred"                      "#bonaPRE-public"                               \
    "nuke"                      "#bonaPRE-public"                               \
    "stats"                     "#bonaPRE-public"                               \
    "spam"                      "#bonaPRE-public"                               \
    "filtre"                    "#bonaPRE-public"                               \
  ]

  # Configuration des champs de la base de données
  array set db_     [list                                                       \
    "id"                        "id"                                            \
    "rlsname"                   "rlsname"                                       \
    "group"                     "group"                                         \
    "section"                   "section"                                       \
    "datetime"                  "datetime"                                      \
    "lastupdated"               "lastupdated"                                   \
    "status"                    "status"                                        \
    "files"                     "files"                                         \
    "size"                      "size"                                          \
  ]

  # Configuration des champs pour les releases nuke
  array set nuke_   [list                                                       \
    "id"                        "id"                                            \
    "rlsname"                   "rlsname"                                       \
    "group"                     "group"                                         \
    "datetime"                  "datetime"                                      \
    "nuke"                      "nuke"                                          \
    "raison"                    "raison"                                        \
    "nukenet"                   "nukenet"                                       \
  ]

  # Configuration des champs pour les suppressions
  array set del_    [list                                                       \
    "id"                        "id"                                            \
    "releaseName"               "releaseName"                                   \
    "groupName"                 "groupName"                                     \
    "datetime"                  "datetime"                                      \
    "typeName"                  "typeName"                                      \
    "reasonMessage"             "reasonMessage"                                 \
    "delNetName"                "delNetName"                                    \
  ]

  # Configuration des champs pour les URL de la base de données
  array set dburl_  [list                                                       \
    "id"                        "id"                                            \
    "rlsname"                   "rlsname"                                       \
    "group"                     "group"                                         \
    "lastupdated"               "lastupdated"                                   \
    "addurl"                    "addurl"                                        \
    "imdb"                      "imdb"                                          \
    "tvmaze"                    "tvmaze"                                        \
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
