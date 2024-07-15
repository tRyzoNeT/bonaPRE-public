proc ::bonaPRE::dupe:init { args } {
	if { [catch { package require bonaPRE-SQL 1.1 }] } {
		set AE_LOGERR 	[format "${::bonaPRE::VAR(release)} modTCL * le fichier mysql.tcl doit être charger avant dupe.tcl"]
		return -code error ${AE_LOGERR};
	}
}

bind pub -|- !dupe ::bonaPRE::dupe

proc ::bonaPRE::dupe { nick uhost hand chan arg } {
	set DP_Rlsname [lindex ${arg} 0]
	if { ![channel get ${chan} bpsearch] } {
		set DP_LOGERR	[format "L'utilisateur %s à tenté un !dupe sur %s, mais le salon n'a pas les *flags* necéssaire." ${nick} ${chan}]
		set DP_MSGERR	[format "%s à tenté un !dupe, mais le salon n'a pas les *flags* necéssaire." ${nick}]
		putquick "privmsg ${chan} ${DP_MSGERR}"
		return -code error ${DP_LOGERR};
	}
	if { ${DP_Rlsname} == "" } {
		set DP_LOGERR	[format "Syntax * %s à tenté un !dupe sur %s, mais manque d'information..." ${nick} ${chan}]
		set DP_MSGERR	[format "Syntax * !dupe <nom.de.la.release>"]
		putquick "privmsg ${chan} ${DP_MSGERR}"
		return -code error ${DP_LOGERR};
	}
	set DP_Sql          "SELECT `${::bonaPRE::db_(id)}`, `${::bonaPRE::db_(rlsname)}`, `${::bonaPRE::db_(section)}`, `${::bonaPRE::db_(datetime)}`";
	append DP_Sql       "FROM `${::bonaPRE::mysql_(dbmain)}` ";
	append DP_Sql       "WHERE `${::bonaPRE::db_(rlsname)}` LIKE '${DP_Rlsname}%' ";
	append DP_Sql       "ORDER BY ${::bonaPRE::db_(datetime)} DESC LIMIT 5;";
	set DP_Sqld		[::mysql::sel ${::bonaPRE::mysql_(handle)} ${DP_Sql} -flatlist];
	if { ${DP_Sqld} != "" } {
		# (lassign) La Liste SQL separer en variables https://www.tcl.tk/man/tcl8.7/TclCmd/lassign.html
		lassign  ${DP_Sqld} DP_Id DP_Rls DP_Section DP_Datetime;
        set DP_CTIME     [clock scan "${DP_Datetime}"]
        set DP_UTIME     [unixtime]
        set DP_AGO       [duration [expr {${DP_CTIME} - ${DP_UTIME}}]]
		set DP_MSGOK1 [format "\002\0033(\0037DUPE\0033)\002\0037 ${DP_Rls} \0033-\00315\002 ${DP_Section} \002\0033(\0037id:\0038 ${DP_Id}\0033) ${DP_Datetime} - ${DP_CTIME} - ${DP_AGO}"]
		putquick "privmsg ${chan} ${DP_MSGOK1}"
		return false;
	} else {
  		set DP_MSGERR [format "\002\0033(\0037DUPE\0033)\002\0037 ${DP_Rlsname} \00315inexistant dans la database."]
  		putquick "privmsg ${chan} ${DP_MSGERR}"
		return false;
	}
}

package provide bonaPRE-DUPE-PUBLiC 1.1
putlog "Tcl load \[::${::bonaPRE::VAR(release)}::DUPE\]: modTCL chargé."
