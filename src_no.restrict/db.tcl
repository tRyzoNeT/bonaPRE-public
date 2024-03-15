proc ::bonaPRE::mysqldb:init { args } {
	if { [catch { package require bonaPRE-SQL 1.0 }] } {
		set AE_LOGERR 	[format "${::bonaPRE::VAR(release)} modTCL * le fichier mysql.tcl doit être charger avant db.tcl"]
		return -code error ${AE_LOGERR};
	}
}
::bonaPRE::mysqldb:init

bind pub -|- !db ::bonaPRE::dbexec

proc ::bonaPRE::dbexec { nick uhost hand chan arg } {
	if { ![channel get ${chan} bpdb] } {
		set DB_LOGERR	[format "L'utilisateur %s à tenté un !%s sur %s, mais le salon n'a pas les *flags* necéssaire." ${nick} !db ${chan}]
		set DB_MSGERR	[format "%s à tenté un !%s, mais le salon n'a pas les *flags* necéssaire." ${nick} !db]
		putquick "privmsg ${chan} ${DB_MSGERR}"
		return -code error ${DB_LOGERR};
	}
	set DB_Sql		"SELECT COUNT(id) FROM ${::bonaPRE::mysql_(dbmain)}";
	set DB_Sel		[::mysql::sel ${::bonaPRE::mysql_(handle)} ${DB_Sql}];
	set DB_Sqld		[::mysql::map ${::bonaPRE::mysql_(handle)} {DB_Cid} { set DB_All ${DB_Cid} }];
	set NK_Sql		"SELECT COUNT(id) FROM ${::bonaPRE::mysql_(dbnuke)}";
	set NK_Sel		[::mysql::sel ${::bonaPRE::mysql_(handle)} ${NK_Sql}];
	set NK_Sqld		[::mysql::map ${::bonaPRE::mysql_(handle)} {NK_Cid} { set NK_All ${NK_Cid} }];	
	putquick "privmsg ${chan} (MySQL) PRiNCiPAL ${DB_All} - Nuke ${NK_All}"
	return false;
}
package provide bonaPRE-MYSQLDB 1.0
putlog "Tcl load \[::${::bonaPRE::VAR(release)}::MYSQLDB\]: modTCL chargé."
