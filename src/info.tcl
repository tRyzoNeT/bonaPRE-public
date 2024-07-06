proc ::bonaPRE::info:init { args } {
	if { [catch { package require bonaPRE-SQL 1.1 }] } {
		set AI_LOGERR 	[format "${::bonaPRE::VAR(release)} modTCL * le fichier mysql.tcl doit être charger avant info.tcl"]
		return -code error ${AI_LOGERR};
	}
}
::bonaPRE::info:init

bind pub -|- !info ::bonaPRE::ainfo
bind pub -|- !oldinfo ::bonaPRE::oinfo

proc ::bonaPRE::ainfo { nick uhost hand chan arg } {
	set I_Time 		"%Y-%m-%d %H:%M:%S"
	set I_DateTime 	[clock format [clock seconds] -format $I_Time]
	set I_Name     	[lindex ${arg} 0]
	set I_Files   	[lindex ${arg} 1]
	set I_Size	   	[lindex ${arg} 2]
	set I_Chan 		${chan}
	::bonaPRE::addinfo ${nick} ${I_Chan} ${I_DateTime} ${I_Name} ${I_Files} ${I_Size} INFO
	return false;
}

proc ::bonaPRE::oinfo { nick uhost hand chan arg } {
	set IO_Time 	"%Y-%m-%d %H:%M:%S"
	set IO_DateTime [clock format [clock seconds] -format $IO_Time]
	set IO_Name     [lindex ${arg} 0]
	set IO_Files   	[lindex ${arg} 1]
	set IO_Size	   	[lindex ${arg} 2]
	set IO_Chan 	${chan}
	::bonaPRE::addinfo ${nick} ${IO_Chan} ${IO_DateTime} ${IO_Name} ${IO_Files} ${IO_Size} OLDINFO
	return false;
}

proc ::bonaPRE::addinfo { args } {
	set AI_Nick [lindex ${args} 0]
	set AI_Chan [lindex ${args} 1]
	set AI_Time [lindex ${args} 2]
	set AI_Rls	[lindex ${args} 3]
	set AI_File	[lindex ${args} 4]
	set AI_Size	[lindex ${args} 5]
	set AI_Sta	[lindex ${args} 6]
	if { ![channel get ${AI_Chan} bpadd] } {
		set AI_LOGERR	[format "L'utilisateur %s à tenté un !%s sur %s, mais le salon n'a pas les *flags* necéssaire." ${AI_Nick} ${AI_Sta} ${AI_Chan}]
		set AI_MSGERR	[format "%s à tenté un !%s, mais le salon n'a pas les *flags* necéssaire." ${AI_Nick} ${AI_Sta}]
		putquick "privmsg ${AI_Chan} ${AI_MSGERR}"
		return -code error ${AI_LOGERR};
	}
	if { ${AI_Size} == "" } {
		set AI_LOGERR	[format "Syntax * %s à tenté un !%s sur %s, mais manque d'information..." ${AI_Nick} ${AI_Sta} ${AI_Chan}]
		if { ${AI_Sta} == "INFO" } { set AI_MSGERR	[format "Syntax * !%s <nom.de.la.release> <fichier> <taille>" ${AI_Sta}] }
		if { ${AI_Sta} == "OLDINFO" } { set AI_MSGERR	[format "Syntax * !%s <nom.de.la.release> <fichier> <taille>" ${AI_Sta}] }
		putquick "privmsg ${AI_Chan} ${AI_MSGERR}"
		return -code error ${AI_LOGERR};
	}
	set AI_SqlUP      	"UPDATE `${::bonaPRE::mysql_(dbmain)}` ";
	append AI_SqlUP   	"SET `${::bonaPRE::db_(lastupdated)}`='${AI_Time}', `${::bonaPRE::db_(files)}`='${AI_File}', `${::bonaPRE::db_(size)}`='${AI_Size}' ";
	append AI_SqlUP   	"WHERE `${::bonaPRE::db_(rlsname)}`='${AI_Rls}';";
	set AI_SqldUP		[::mysql::exec ${::bonaPRE::mysql_(handle)} ${AI_SqlUP}];
	set AI_Sqldid1		"SELECT `${::bonaPRE::db_(id)}` FROM `${::bonaPRE::mysql_(dbmain)}` WHERE `${::bonaPRE::db_(rlsname)}` LIKE '${AI_Rls}%'";
	set AI_Sqldid2		[::mysql::sel ${::bonaPRE::mysql_(handle)} ${AI_Sqldid1} -flatlist];
	lassign  ${AI_Sqldid2} AI_SqlidOK;
	set AI_LOGOK		[format "Tcl exec \[::${::bonaPRE::VAR(release)}::${AI_Sta}\]: L'exécution de la requête %s pour %s (id: %s)" ${AI_SqldUP} ${AI_Rls} ${AI_SqlidOK}]
	set AI_MSGOK		[format "%s - %s fichier %s mb (id: %s)" ${AI_Rls} ${AI_File} ${AI_Size} ${AI_SqlidOK}]
	putquick "privmsg ${::bonaPRE::chan_(spam)} ${AI_MSGOK}"
	putlog "${AI_LOGOK}"
	return false;
}
package provide bonaPRE-INFO 1.1
putlog "Tcl load \[::${::bonaPRE::VAR(release)}::ADD\]: modTCL chargé."
