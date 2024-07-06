proc ::bonaPRE::mysqldb:init { args } {
	if { [catch { package require bonaPRE-SQL 1.1 }] } {
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
	if { [lindex ${arg} 0] == "" } {
		set DB_Sql		"SELECT COUNT(id) FROM ${::bonaPRE::mysql_(dbmain)}";
		set DB_Sel		[::mysql::sel ${::bonaPRE::mysql_(handle)} ${DB_Sql}];
		set DB_Sqld		[::mysql::map ${::bonaPRE::mysql_(handle)} {DB_Cid} { set DB_All ${DB_Cid} }];
		set NK_Sql		"SELECT COUNT(id) FROM ${::bonaPRE::mysql_(dbnuke)}";
		set NK_Sel		[::mysql::sel ${::bonaPRE::mysql_(handle)} ${NK_Sql}];
		set NK_Sqld		[::mysql::map ${::bonaPRE::mysql_(handle)} {NK_Cid} { set NK_All ${NK_Cid} }];
		putquick "privmsg ${chan} \002\0033(\0037MySQL\0033)\002 \00310PRiNCiPAL\0039 ${DB_All} \0033-\00310 Nuke\0034 ${NK_All}"
		return false;
	}
	if { [lindex ${arg} 0] == "main" } {
		set DB_Sql1		"SELECT COUNT(id) FROM ${::bonaPRE::mysql_(dbmain)}";
		set DB_Sel1		[::mysql::sel ${::bonaPRE::mysql_(handle)} ${DB_Sql1}];
		set DB_Sqld1	[::mysql::map ${::bonaPRE::mysql_(handle)} {DB_Cid} { set DB_All ${DB_Cid} }];
		set DB_Sql2		"SELECT COUNT(*) FROM ${::bonaPRE::mysql_(dbmain)} WHERE status = 'ADDPRE'";
		set DB_Sel2		[::mysql::sel ${::bonaPRE::mysql_(handle)} ${DB_Sql2}];
		set DB_Sqld2	[::mysql::map ${::bonaPRE::mysql_(handle)} {DB_Capre} { set DB_Apre ${DB_Capre} }];
		set DB_Sql3		"SELECT COUNT(*) FROM ${::bonaPRE::mysql_(dbmain)} WHERE status = 'SITEPRE'";
		set DB_Sel3		[::mysql::sel ${::bonaPRE::mysql_(handle)} ${DB_Sql3}];
		set DB_Sqld3	[::mysql::map ${::bonaPRE::mysql_(handle)} {DB_Cspre} { set DB_Spre ${DB_Cspre} }];
		set DB_Sql4		"SELECT COUNT(*) FROM ${::bonaPRE::mysql_(dbmain)} WHERE status = 'ADDOLD'";
		set DB_Sel4		[::mysql::sel ${::bonaPRE::mysql_(handle)} ${DB_Sql4}];
		set DB_Sqld4	[::mysql::map ${::bonaPRE::mysql_(handle)} {DB_Caold} { set DB_Aold ${DB_Caold} }];
		set DB_Sql5		"SELECT COUNT(*) FROM ${::bonaPRE::mysql_(dbmain)} WHERE status = ''";
		set DB_Sel5		[::mysql::sel ${::bonaPRE::mysql_(handle)} ${DB_Sql5}];
		set DB_Sqld5	[::mysql::map ${::bonaPRE::mysql_(handle)} {DB_Cainv} { set DB_Ainv ${DB_Cainv} }];
		putquick "privmsg ${chan} \002\0033(\0037MySQL\0033)\002 \00310TOTAL\0039 ${DB_All}"
		putquick "privmsg ${chan} \002\0033(\0037XTRA\0033)\002 \00310ADDPRE\0039 ${DB_Apre} \0033-\00310 SiTEPRE\0039 ${DB_Spre} \0033-\00310 ADDOLD\0039 ${DB_Aold} \0033-\00310 iNVALiDE\0034 ${DB_Ainv}"
		return false;
	}
	if { [lindex ${arg} 0] == "nuke" } {
		set NK_Sql1		"SELECT COUNT(id) FROM ${::bonaPRE::mysql_(dbnuke)}";
		set NK_Sel1		[::mysql::sel ${::bonaPRE::mysql_(handle)} ${NK_Sql1}];
		set NK_Sqld1	[::mysql::map ${::bonaPRE::mysql_(handle)} {NK_Cid} { set NK_All ${NK_Cid} }];
		set NK_Sql2		"SELECT COUNT(*) FROM ${::bonaPRE::mysql_(dbnuke)} WHERE nuke = 'DELPRE'";
		set NK_Sel2		[::mysql::sel ${::bonaPRE::mysql_(handle)} ${NK_Sql2}];
		set NK_Sqld2	[::mysql::map ${::bonaPRE::mysql_(handle)} {NK_Cdpre} { set NK_Dpre ${NK_Cdpre} }];
		set NK_Sql3		"SELECT COUNT(*) FROM ${::bonaPRE::mysql_(dbnuke)} WHERE nuke = 'NUKE'";
		set NK_Sel3		[::mysql::sel ${::bonaPRE::mysql_(handle)} ${NK_Sql3}];
		set NK_Sqld3	[::mysql::map ${::bonaPRE::mysql_(handle)} {NK_Cnuke} { set NK_Nuke ${NK_Cnuke} }];
		set NK_Sql4		"SELECT COUNT(*) FROM ${::bonaPRE::mysql_(dbnuke)} WHERE nuke = 'MODDELPRE'";
		set NK_Sel4		[::mysql::sel ${::bonaPRE::mysql_(handle)} ${NK_Sql4}];
		set NK_Sqld4	[::mysql::map ${::bonaPRE::mysql_(handle)} {NK_Cmdel} { set NK_Mdel ${NK_Cmdel} }];
		set NK_Sql5		"SELECT COUNT(*) FROM ${::bonaPRE::mysql_(dbnuke)} WHERE nuke = 'MODNUKE'";
		set NK_Sel5		[::mysql::sel ${::bonaPRE::mysql_(handle)} ${NK_Sql5}];
		set NK_Sqld5	[::mysql::map ${::bonaPRE::mysql_(handle)} {NK_Cmnuke} { set NK_Mnuke ${NK_Cmnuke} }];
		set NK_Sql6		"SELECT COUNT(*) FROM ${::bonaPRE::mysql_(dbnuke)} WHERE nuke = 'MODUNNUKE'";
		set NK_Sel6		[::mysql::sel ${::bonaPRE::mysql_(handle)} ${NK_Sql6}];
		set NK_Sqld6	[::mysql::map ${::bonaPRE::mysql_(handle)} {NK_Cmunuke} { set NK_Munuke ${NK_Cmunuke} }];
		set NK_Sql7		"SELECT COUNT(*) FROM ${::bonaPRE::mysql_(dbnuke)} WHERE nuke = 'UNDELPRE'";
		set NK_Sel7		[::mysql::sel ${::bonaPRE::mysql_(handle)} ${NK_Sql7}];
		set NK_Sqld7	[::mysql::map ${::bonaPRE::mysql_(handle)} {NK_Cudel} { set NK_Udel ${NK_Cudel} }];
		set NK_Sql8		"SELECT COUNT(*) FROM ${::bonaPRE::mysql_(dbnuke)} WHERE nuke = 'UNNUKE'";
		set NK_Sel8		[::mysql::sel ${::bonaPRE::mysql_(handle)} ${NK_Sql8}];
		set NK_Sqld8	[::mysql::map ${::bonaPRE::mysql_(handle)} {NK_Cunuke} { set NK_Unuke ${NK_Cunuke} }];
		putquick "privmsg ${chan} \002\0033(\0037MySQL\0033)\002 \00310TOTAL\0034 ${NK_All}"
		putquick "privmsg ${chan} \002\0033(\0037XTRA\0033)\002 \00310DELPRE\0039 ${NK_Dpre} \0033-\00310 NUKE\0034 ${NK_Nuke}"
		putquick "privmsg ${chan} \002\0033(\0037XTRA\0033)\002 \00310MODDELPRE\0039 ${NK_Mdel} \0033-\00310 MODNUKE\0035 ${NK_Mnuke} \0033-\00310 MODUNNUKE\0039 ${NK_Munuke}"
		putquick "privmsg ${chan} \002\0033(\0037XTRA\0033)\002 \00310UNDELPRE\0039 ${NK_Udel} \0033-\00310 UNNUKE\0039 ${NK_Unuke}"
		return false;
	} else { 
		set DB_MSGERR	[format "Syntax * !db 'main ou nuke'"]
		putquick "privmsg ${chan} ${DB_MSGERR}"
		return false;
	}
}

package provide bonaPRE-MYSQLDB 1.1
putlog "Tcl load \[::${::bonaPRE::VAR(release)}::MYSQLDB\]: modTCL chargé."
