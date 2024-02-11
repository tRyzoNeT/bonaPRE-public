proc ::bonaPRE::pre:init { args } {
	if { [catch { package require bonaPRE-SQL 1.0 }] } {
		set AE_LOGERR 	[format "${::bonaPRE::VAR(release)} modTCL * le fichier mysql.tcl doit être chargé avant pre.tcl"]
		return -code error ${AE_LOGERR};
	}
}
::bonaPRE::pre:init

bind pub -|- !pre ::bonaPRE::pre

proc ::bonaPRE::pre { nick uhost hand chan arg } {
	set P_Rlsname [lindex ${arg} 0]
	if { ![channel get ${chan} bpsearch] } {
		set P_LOGERR	[format "L'utilisateur %s a tenté un !pre sur %s, mais le salon n'a pas les *flags* necéssaires." ${nick} ${chan}]
		set P_MSGERR	[format "%s a tenté un !pre, mais le salon n'a pas les *flags* necéssaires." ${nick}]
		putquick "privmsg ${chan} ${P_MSGERR}"
		return -code error ${P_LOGERR};
	}
	if { ${P_Rlsname} == "" } {
		set P_LOGERR	[format "Syntax * %s a tenté un !pre sur %s, mais manque d'informations..." ${nick} ${chan}]
		set P_MSGERR	[format "Syntax * !pre <nom.de.la.release>"]
		putquick "privmsg ${chan} ${P_MSGERR}"
		return -code error ${P_LOGERR};
	}
	set P_Sql          "SELECT `${::bonaPRE::db_(id)}`, `${::bonaPRE::db_(rlsname)}`, `${::bonaPRE::db_(section)}`, `${::bonaPRE::db_(datetime)}`, `${::bonaPRE::db_(files)}`, `${::bonaPRE::db_(size)}`";
	append P_Sql       "FROM `${::bonaPRE::mysql_(dbmain)}` ";
	append P_Sql       "WHERE `${::bonaPRE::db_(rlsname)}` LIKE '${P_Rlsname}%' ";
	append P_Sql       "ORDER BY ${::bonaPRE::db_(datetime)} DESC LIMIT 1;";
	set P_Sqld		[::mysql::sel ${::bonaPRE::mysql_(handle)} ${P_Sql} -flatlist];
	if { ${P_Sqld} != "" } {
		# (lassign) La Liste SQL separée en variables https://www.tcl.tk/man/tcl8.7/TclCmd/lassign.html
		lassign  ${P_Sqld} P_Id P_Rls P_Section P_Datetime P_Files P_Size;
		set P_MSGOK1 [format "\002\0033(\0037PRE\0033)\002\0037 ${P_Rls} \0033-\00315\002 ${P_Section} \002\0033(\0037id:\0038 ${P_Id}\0033)"]
  		set P_MSGOK2 [format "\002\0033(\0037DateTiME\0033)\002\00310 ${P_Datetime}"]
		putquick "privmsg ${chan} ${P_MSGOK1}"
		putquick "privmsg ${chan} ${P_MSGOK2}"
		if { ${P_Size} == "" } { } else { 
			set P_MSGOK3 [format "\002\0033(\0037iNFO\0033)\002\0038 ${P_Files} \00310fichier \0033|\00311 ${P_Size} \0037mb "]
			putquick "privmsg ${chan} ${P_MSGOK3}"
		}
		return false;
	} else {
  		set P_MSGERR [format "\002\0033(\0037PRE\0033)\002\0037 ${P_Rlsname} \00315inexistant dans la database."]
  		putquick "privmsg ${chan} ${P_MSGERR}"
		return false;
	}
}
package provide bonaPRE-PRE-PUBLiC 1.0
putlog "Tcl load \[::${::bonaPRE::VAR(release)}::PRE\]: modTCL chargé."
