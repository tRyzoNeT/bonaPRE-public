namespace eval ::bonaPRE {
	array set VAR 	[list													\
   		"release" "bonaPRE"													\
   		"desc" "*TCL PREBOT*"												\
   		"version" "v1.1P"													\
   		"dev" "og"															\
		"git" "https://github.com/tRyzoNeT/bonaPRE-public"					\
	];
	array set mysql_  [list 												\
		"user" 			"mysql_user"										\
		"password" 		"mysql_pass"										\
		"host" 			"mysql_host-ip"										\
		"db" 			"mysql_db"											\
		"dbmain" 		"MAIN"												\
		"dburl" 		"XTRA_URL"											\
		"dbnuke" 		"NUKE"												\
		"conrefresh" 	"2000"												\
	];
	array set url_  [list	 												\
		"tvmaze"		"https://www.tvmaze.com/shows/"						\
		"imdb"			"https://www.imdb.com/title/"						\
	];
	array set chan_ [list													\
		"add"					"#bonaPRE-public"							\
		"pred"					"#bonaPRE-public"							\
		"nuke"					"#bonaPRE-public"							\
		"stats"					"#bonaPRE-public"							\
		"spam"					"#bonaPRE-public"							\
		"filtre"				"#bonaPRE-public"							\
	];
	array set db_ [list														\
		"id" 					"id"										\
		"rlsname" 				"rlsname"									\
		"group" 				"group"										\
		"section" 				"section"									\
		"datetime" 				"datetime"									\
		"lastupdated" 			"lastupdated"								\
		"status" 				"status"									\
		"files" 				"files"										\
		"size" 					"size"										\
	];
	array set nuke_ [list													\
		"id" 					"id"										\
		"rlsname" 				"rlsname"									\
		"group" 				"group"										\
		"datetime" 				"datetime"									\
		"nuke" 					"nuke"										\
		"raison" 				"raison"									\
		"nukenet" 				"nukenet"									\
	];
	array set dburl_ [list													\
		"id" 					"id"										\
		"rlsname" 				"rlsname"									\
		"group" 				"group"										\
		"lastupdated" 			"lastupdated"								\
		"addurl" 				"addurl"									\
		"imdb" 					"imdb"										\
		"tvmaze" 				"tvmaze"									\
	];
	################################################################################
	setudef flag bpadd
	setudef flag bpdb
	setudef flag bpecho
	setudef flag bpfiltre
	setudef flag bpnuke
	setudef flag bpsearch
	setudef flag bpstats
	setudef flag bpurl
	################################################################################
	if { [catch { package require mysqltcl }] } { die "\[configuration.tcl - erreur\] le script nécessite le package mysqltcl." ; return }
	package provide bonaPRE-CONF-PUBLiC 1.1
	putlog "Tcl load \[::${::bonaPRE::VAR(release)}::${::bonaPRE::VAR(version)}::CONFiG\]: modTCL chargé. \[${::bonaPRE::VAR(dev)}\]"
	############################### END OF SCRIPT ##################################
}
