proc ::bonaPRE::oldnuke:init { args } {
	if { [catch { package require bonaPRE-SQL 1.0 }] } { 
		set AE_LOGERR 	[format "${::bonaPRE::VAR(release)} modTCL * le fichier mysql.tcl doit être charger avant oldnuke.tcl"]
		return -code error ${AE_LOGERR};
	}
}
::bonaPRE::oldnuke:init

bind pub -|- !olddelpre ::bonaPRE::olddelpre
bind pub -|- !oldmoddelpre ::bonaPRE::oldmoddelpre
bind pub -|- !oldmodnuke ::bonaPRE::oldmodnuke
bind pub -|- !oldmodunnuke ::bonaPRE::oldmodunnuke
bind pub -|- !oldnuke ::bonaPRE::oldnuke
bind pub -|- !oldundelpre ::bonaPRE::oldundelpre
bind pub -|- !oldunnuke ::bonaPRE::oldunnuke

proc ::bonaPRE::olddelpre { nick uhost hand chan arg } {
	set OD_Name     	[lindex ${arg} 0]
	set OD_Grp      	[lindex [split ${OD_Name} -] end]
	set OD_Raison   	[lindex ${arg} 1]
	set OD_Nukenet  	[lindex ${arg} 2]
	set OD_Date			[lindex ${arg} 3]
	set OD_Time			[lindex ${arg} 4]
	set OD_Echo			[lindex ${arg} 5]
	set OD_Chan 		${chan}
	::bonaPRE::oldnukexec ${nick} ${OD_Chan} ${OD_Date} ${OD_Time} ${OD_Name} ${OD_Grp} ${OD_Raison} ${OD_Nukenet} DELPRE ${OD_Echo}
	return false;
}

proc ::bonaPRE::oldmoddelpre { nick uhost hand chan arg } {
	set OMD_Name     	[lindex ${arg} 0]
	set OMD_Grp      	[lindex [split ${OMD_Name} -] end]
	set OMD_Raison   	[lindex ${arg} 1]
	set OMD_Nukenet  	[lindex ${arg} 2]
	set OMD_Date		[lindex ${arg} 3]
	set OMD_Time		[lindex ${arg} 4]
	set OMD_Echo		[lindex ${arg} 5]
	set OMD_Chan 		${chan}
	::bonaPRE::oldnukexec ${nick} ${OMD_Chan} ${OMD_Date} ${OMD_Time} ${OMD_Name} ${OMD_Grp} ${OMD_Raison} ${OMD_Nukenet} MODDELPRE ${OMD_Echo}
	return false;
}

proc ::bonaPRE::oldmodnuke { nick uhost hand chan arg } {
	set OMN_Name     	[lindex ${arg} 0]
	set OMN_Grp      	[lindex [split ${OMN_Name} -] end]
	set OMN_Raison   	[lindex ${arg} 1]
	set OMN_Nukenet  	[lindex ${arg} 2]
	set OMN_Date		[lindex ${arg} 3]
	set OMN_Time		[lindex ${arg} 4]
	set OMN_Echo		[lindex ${arg} 5]
	set OMN_Chan 		${chan}
	::bonaPRE::oldnukexec ${nick} ${OMN_Chan} ${OMN_Date} ${OMN_Time} ${OMN_Name} ${OMN_Grp} ${OMN_Raison} ${OMN_Nukenet} MODNUKE ${OMN_Echo}
	return false;
}

proc ::bonaPRE::oldmodunnuke { nick uhost hand chan arg } {
	set OMU_Name     	[lindex ${arg} 0]
	set OMU_Grp      	[lindex [split ${OMU_Name} -] end]
	set OMU_Raison   	[lindex ${arg} 1]
	set OMU_Nukenet  	[lindex ${arg} 2]
	set OMU_Date		[lindex ${arg} 3]
	set OMU_Time		[lindex ${arg} 4]
	set OMU_Echo		[lindex ${arg} 5]
	set OMU_Chan 		${chan}
	::bonaPRE::oldnukexec ${nick} ${OMU_Chan} ${OMU_Date} ${OMU_Time} ${OMU_Name} ${OMU_Grp} ${OMU_Raison} ${OMU_Nukenet} MODUNNUKE ${OMU_Echo}
	return false;
}

proc ::bonaPRE::oldnuke { nick uhost hand chan arg } {
	set ON_Name     	[lindex ${arg} 0]
	set ON_Grp      	[lindex [split ${ON_Name} -] end]
	set ON_Raison   	[lindex ${arg} 1]
	set ON_Nukenet  	[lindex ${arg} 2]
	set ON_Date			[lindex ${arg} 3]
	set ON_Time			[lindex ${arg} 4]
	set ON_Echo			[lindex ${arg} 5]
	set ON_Chan 		${chan}
	::bonaPRE::oldnukexec ${nick} ${ON_Chan} ${ON_Date} ${ON_Time} ${ON_Name} ${ON_Grp} ${ON_Raison} ${ON_Nukenet} NUKE ${ON_Echo}
	return false;
}

proc ::bonaPRE::oldundelpre { nick uhost hand chan arg } {
	set OUD_Name     	[lindex ${arg} 0]
	set OUD_Grp      	[lindex [split ${OUD_Name} -] end]
	set OUD_Raison   	[lindex ${arg} 1]
	set OUD_Nukenet  	[lindex ${arg} 2]
	set OUD_Date		[lindex ${arg} 3]
	set OUD_Time		[lindex ${arg} 4]
	set OUD_Echo		[lindex ${arg} 5]
	set OUD_Chan 		${chan}
	::bonaPRE::oldnukexec ${nick} ${OUD_Chan} ${OUD_Date} ${OUD_Time} ${OUD_Name} ${OUD_Grp} ${OUD_Raison} ${OUD_Nukenet} UNDELPRE ${OUD_Echo}
	return false;
}

proc ::bonaPRE::oldunnuke { nick uhost hand chan arg } {
	set OUN_Name     	[lindex ${arg} 0]
	set OUN_Grp      	[lindex [split ${OUN_Name} -] end]
	set OUN_Raison   	[lindex ${arg} 1]
	set OUN_Nukenet  	[lindex ${arg} 2]
	set OUN_Date		[lindex ${arg} 3]
	set OUN_Time		[lindex ${arg} 4]
	set OUN_Echo		[lindex ${arg} 5]
	set OUN_Chan 		${chan}
	::bonaPRE::oldnukexec ${nick} ${OUN_Chan} ${OUN_Date} ${OUN_Time} ${OUN_Name} ${OUN_Grp} ${OUN_Raison} ${OUN_Nukenet} UNNUKE ${OUN_Echo}
	return false;
}

proc ::bonaPRE::oldnukexec { args } {
	set OEX_Nick	[lindex ${args} 0]
	set OEX_Chan	[lindex ${args} 1]
	set OEX_Date	[lindex ${args} 2]
	set OEX_Time	[lindex ${args} 3]
	set OEX_Rls		[lindex ${args} 4]
	set OEX_Grp		[lindex ${args} 5]
	set OEX_Ra		[lindex ${args} 6]
	set OEX_Nnet	[lindex ${args} 7]
	set OEX_Sta		[lindex ${args} 8]
	set OEX_Ech		[lindex ${args} 9]
	if { ![channel get ${OEX_Chan} bpnuke] } {
		set OEX_LOGERR	[format "L'utilisateur %s à tenté un !old%s sur %s, mais le salon n'a pas les *flags* necéssaire." ${OEX_Nick} ${OEX_Sta} ${OEX_Chan}]
		set OEX_MSGERR	[format "%s à tenté un !old%s, mais le salon n'a pas les *flags* necéssaire." ${OEX_Nick} ${OEX_Sta}]
		putquick "privmsg ${OEX_Chan} ${OEX_MSGERR}"
		return -code error ${OEX_LOGERR};
	}
	if { ${OEX_Nnet} == "" } {
		set OEX_LOGERR	[format "Syntax * %s à tenté un !old%s sur %s, mais manque d'information..." ${OEX_Nick} ${OEX_Sta} ${OEX_Chan}]
		set OEX_MSGERR	[format "Syntax * !old%s <nom.de.la.release> <raison> <nukenet> <datetime> **2022-10-21 23:56:21**" ${OEX_Sta}]
		putquick "privmsg ${OEX_Chan} ${OEX_MSGERR}"
		return -code error ${OEX_LOGERR};
	}
	set OEX_Sql       "INSERT INTO ${::bonaPRE::mysql_(dbnuke)} "
	append OEX_Sql    "( `${::bonaPRE::nuke_(rlsname)}`, `${::bonaPRE::nuke_(group)}`, `${::bonaPRE::nuke_(datetime)}`, `${::bonaPRE::nuke_(nuke)}`, `${::bonaPRE::nuke_(raison)}`, `${::bonaPRE::nuke_(nukenet)}` ) ";
	append OEX_Sql    "VALUES ( '${OEX_Rls}', '${OEX_Grp}', '${OEX_Date} ${OEX_Time}', '${OEX_Sta}', '${OEX_Ra}', '${OEX_Nnet}' );";
	set OEX_Sqld 	    [::mysql::exec ${::bonaPRE::mysql_(handle)} ${OEX_Sql}];
	set OEX_Sqlid [::mysql::insertid ${::bonaPRE::mysql_(handle)}]
	if {  ${OEX_Sqld} == "1" } {
		if { ${OEX_Ech} == "0" } {
			set OEX_LOGOK	[format "Tcl exec \[::${::bonaPRE::VAR(release)}::NUKE\]: L'exécution de la requête %s pour %s (id: %s)" ${OEX_Sqld} ${OEX_Rls} ${OEX_Sqlid}]
			putlog "${OEX_LOGOK}"
			return false;
		} else {
			set OEX_LOGOK	[format "Tcl exec \[::${::bonaPRE::VAR(release)}::NUKE\]: L'exécution de la requête %s pour %s (id: %s)" ${OEX_Sqld} ${OEX_Rls} ${OEX_Sqlid}]
			set OEX_MSGOK	[format "(%s) %s - %s / %s (%s)" ${OEX_Sta} ${OEX_Rls} ${OEX_Ra} ${OEX_Nnet} ${OEX_Sqlid}]
			putquick "privmsg ${::bonaPRE::chan_(nuke)} ${OEX_MSGOK}"
			putlog "${OEX_LOGOK}"
			return false;
		}
	} else {
		set OEX_LOGERR [format "La release %s n'a pas été ajoutée (WEiRD?!?) par %s/%s" ${OEX_Rls} ${OEX_Chan} ${OEX_Nick}]
		set OEX_MSGERR [format "%s n'a pas été ajoutée (WEiRD?!?)" ${OEX_Rls}]
		putquick "privmsg ${OEX_Chan} ${OEX_MSGERR}"
		return -code error ${OEX_LOGERR};
    }
}
package provide bonaPRE-OLDNUKE 1.0
putlog "Tcl load \[::${::bonaPRE::VAR(release)}::OLDNUKE\]: modTCL chargé."
