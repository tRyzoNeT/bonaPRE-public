proc ::bonaPRE::mysqldb:init { args } {
	if { [catch { package require bonaPRE-SQL 1.0 }] } {
		set dbh_LOGERR 	[format "${::bonaPRE::VAR(release)} modTCL * le fichier mysql.tcl doit être charger avant dbhour.tcl"]
		return -code error ${dbh_LOGERR};
	}
}
::bonaPRE::mysqldb:init

bind time -|- "00 * * * *" ::bonaPRE::dbhexec
proc ::bonaPRE::dbhexec { min hour day month year } {
    set dbhp_Sql1    "SELECT COUNT(*) FROM ${::bonaPRE::mysql_(dbmain)} WHERE ${::bonaPRE::db_(datetime)} > CURRENT_TIMESTAMP - INTERVAL 1 HOUR";
    set dbhp_Sel1   [::mysql::sel ${::bonaPRE::mysql_(handle)} ${dbhp_Sql1}];
    set dbhp_Sqld1  [::mysql::map ${::bonaPRE::mysql_(handle)} {dbhp_cm} { set dbhp_cmadd ${dbhp_cm} }];
    set dbhp_Sql2    "SELECT COUNT(*) FROM ${::bonaPRE::mysql_(dbnuke)} WHERE ${::bonaPRE::db_(datetime)} > CURRENT_TIMESTAMP - INTERVAL 1 HOUR";
    set dbhp_Sel2   [::mysql::sel ${::bonaPRE::mysql_(handle)} ${dbhp_Sql2}];
    set dbhp_Sqld2  [::mysql::map ${::bonaPRE::mysql_(handle)} {dbhp_cn} { set dbhp_cnadd ${dbhp_cn} }];
    putquick "privmsg ${::bonaPRE::chan_(stats)} \002\0033(\0037HOURS\0033)\002 \00315depuis la dernière heure"
    putquick "privmsg ${::bonaPRE::chan_(stats)} \002\0033(\0037MySQL\0033)\002 \00310ADDPRE\0038 ${dbhp_cm} - \00310NUKE\0034 ${dbhp_cn}"
    return false;
}

bind pub -|- !hour ::bonaPRE::dbhpublic
proc ::bonaPRE::dbhpublic { nick uhost hand chan arg } {
    if { ![channel get ${chan} bpdb] } {
        set DB_LOGERR	[format "L'utilisateur %s à tenté un !%s sur %s, mais le salon n'a pas les *flags* necéssaire." ${nick} !hour ${chan}]
		set DB_MSGERR	[format "%s à tenté un !%s, mais le salon n'a pas les *flags* necéssaire." ${nick} !hour]
		putquick "privmsg ${chan} ${DB_MSGERR}"
		return -code error ${DB_LOGERR};
    }
    set dbhp_Sql1    "SELECT COUNT(*) FROM ${::bonaPRE::mysql_(dbmain)} WHERE ${::bonaPRE::db_(datetime)} > CURRENT_TIMESTAMP - INTERVAL 1 HOUR";
    set dbhp_Sel1   [::mysql::sel ${::bonaPRE::mysql_(handle)} ${dbhp_Sql1}];
    set dbhp_Sqld1  [::mysql::map ${::bonaPRE::mysql_(handle)} {dbhp_cm} { set dbhp_cmadd ${dbhp_cm} }];
    set dbhp_Sql2    "SELECT COUNT(*) FROM ${::bonaPRE::mysql_(dbnuke)} WHERE ${::bonaPRE::db_(datetime)} > CURRENT_TIMESTAMP - INTERVAL 1 HOUR";
    set dbhp_Sel2   [::mysql::sel ${::bonaPRE::mysql_(handle)} ${dbhp_Sql2}];
    set dbhp_Sqld2  [::mysql::map ${::bonaPRE::mysql_(handle)} {dbhp_cn} { set dbhp_cnadd ${dbhp_cn} }];
    putquick "privmsg ${chan} \002\0033(\0037HOURS\0033)\002 \00315depuis la dernière heure"
    putquick "privmsg ${chan} \002\0033(\0037MySQL\0033)\002 \00310ADDPRE\0038 ${dbhp_cm} - \00310NUKE\0034 ${dbhp_cn}"
    return false;

}

package provide bonaPRE-MYSQLDBHOUR 1.0
putlog "Tcl load \[::${::bonaPRE::VAR(release)}::MYSQLDBHOUR\]: modTCL chargé."
