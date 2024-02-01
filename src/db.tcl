proc ::bonaPRE::mysqldb:init { args } {
	if { [catch { package require bonaPRE-SQL 1.0 }] } {
		set AE_LOGERR 	[format "${::bonaPRE::VAR(release)} modTCL * le fichier mysql.tcl doit être chargé avant db.tcl"]
		return -code error ${AE_LOGERR};
	}
}
::bonaPRE::mysqldb:init

bind pub -|- !db ::bonaPRE::dbexec

proc ::bonaPRE::dbexec { nick uhost hand chan arg } {
	if { [getuser ${nick} XTRA uauth] == 1 } {
		if { ![channel get ${chan} bpdb] } {
			set DB_LOGERR	[format "L'utilisateur %s a tenté un !%s sur %s, mais le salon n'a pas les *flags* necéssaires." ${nick} !db ${chan}]
			# set DB_MSGERR	[format "%s a tenté un !%s, mais le salon n'a pas les *flags* necéssaires." ${nick} !db]
			# putquick "privmsg ${chan} ${DB_MSGERR}"
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
	} else {
		set DB_LOGERR 	[format "uAUTH * %s n'est pas iDENTiFiÉ au EGGDROP..." ${nick}]
		set DB_MSGERR	[format "uAUTH * TU n'es pas iDENTiFiÉ au EGGDROP... CouCOU!!"]
  		putquick "privmsg ${chan} ${DB_MSGERR}"
  		return -code error ${DB_LOGERR};
	}
}
package provide bonaPRE-MYSQLDB 1.0
putlog "Tcl load \[::${::bonaPRE::VAR(release)}::MYSQLDB\]: modTCL chargé."
