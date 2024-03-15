proc ::bonaPRE::nuke:init { args } {
	if { [catch { package require bonaPRE-SQL 1.0 }] } { 
		set AE_LOGERR 	[format "${::bonaPRE::VAR(release)} modTCL * le fichier mysql.tcl doit être charger avant nuke.tcl"]
		return -code error ${AE_LOGERR};
	}
}
::bonaPRE::nuke:init

bind pub -|- !delpre ::bonaPRE::delpre
bind pub -|- !nuke ::bonaPRE::nuke
bind pub -|- !moddelpre ::bonaPRE::moddelpre
bind pub -|- !modnuke ::bonaPRE::modnuke
bind pub -|- !modunnuke ::bonaPRE::modunnuke
bind pub -|- !undelpre ::bonaPRE::undelpre
bind pub -|- !unnuke ::bonaPRE::unnuke

proc ::bonaPRE::delpre { nick uhost hand chan arg } {
	set D_Time 		"%Y-%m-%d %H:%M:%S"
	set D_DateTime 	[clock format [clock seconds] -format $D_Time] 
	set D_Name     	[lindex ${arg} 0]
	set D_Grp      	[lindex [split ${D_Name} -] end]
	set D_Raison   	[lindex ${arg} 1]
	set D_Nukenet  	[lindex ${arg} 2]
	set D_Echo	   	[lindex ${arg} 3]
	set D_Chan 		${chan}
	::bonaPRE::nukexec ${nick} ${D_Chan} ${D_DateTime} ${D_Name} ${D_Grp} ${D_Raison} ${D_Nukenet} DELPRE ${D_Echo}
	return false;
}

proc ::bonaPRE::nuke { nick uhost hand chan arg } {
	set N_Time 		"%Y-%m-%d %H:%M:%S"
	set N_DateTime 	[clock format [clock seconds] -format $N_Time] 
	set N_Name     	[lindex ${arg} 0]
	set N_Grp      	[lindex [split ${N_Name} -] end]
	set N_Raison   	[lindex ${arg} 1]
	set N_Nukenet  	[lindex ${arg} 2]
	set N_Echo	   	[lindex ${arg} 3]
	set N_Chan 		${chan}
	::bonaPRE::nukexec ${nick} ${N_Chan} ${N_DateTime} ${N_Name} ${N_Grp} ${N_Raison} ${N_Nukenet} NUKE ${N_Echo}
	return false;
}

proc ::bonaPRE::moddelpre { nick uhost hand chan arg } {
	set MD_Time 		"%Y-%m-%d %H:%M:%S"
	set MD_DateTime 	[clock format [clock seconds] -format $MD_Time] 
	set MD_Name     	[lindex ${arg} 0]
	set MD_Grp      	[lindex [split ${MD_Name} -] end]
	set MD_Raison   	[lindex ${arg} 1]
	set MD_Nukenet  	[lindex ${arg} 2]
	set MD_Echo		   	[lindex ${arg} 3]
	set MD_Chan 		${chan}
	::bonaPRE::nukexec ${nick} ${MD_Chan} ${MD_DateTime} ${MD_Name} ${MD_Grp} ${MD_Raison} ${MD_Nukenet} MODDELPRE ${MD_Echo}
	return false;
}

proc ::bonaPRE::modnuke { nick uhost hand chan arg } {
	set MN_Time 		"%Y-%m-%d %H:%M:%S"
	set MN_DateTime 	[clock format [clock seconds] -format $MN_Time] 
	set MN_Name     	[lindex ${arg} 0]
	set MN_Grp      	[lindex [split ${MN_Name} -] end]
	set MN_Raison   	[lindex ${arg} 1]
	set MN_Nukenet  	[lindex ${arg} 2]
	set MN_Echo		   	[lindex ${arg} 3]
	set MN_Chan 		${chan}
	::bonaPRE::nukexec ${nick} ${MN_Chan} ${MN_DateTime} ${MN_Name} ${MN_Grp} ${MN_Raison} ${MN_Nukenet} MODNUKE ${MN_Echo}
	return false;
}

proc ::bonaPRE::modunnuke { nick uhost hand chan arg } {
	set MU_Time 		"%Y-%m-%d %H:%M:%S"
	set MU_DateTime 	[clock format [clock seconds] -format $MU_Time] 
	set MU_Name     	[lindex ${arg} 0]
	set MU_Grp      	[lindex [split ${MU_Name} -] end]
	set MU_Raison   	[lindex ${arg} 1]
	set MU_Nukenet  	[lindex ${arg} 2]
	set MU_Echo		   	[lindex ${arg} 3]
	set MU_Chan 		${chan}
	::bonaPRE::nukexec ${nick} ${MU_Chan} ${MU_DateTime} ${MU_Name} ${MU_Grp} ${MU_Raison} ${MU_Nukenet} MODUNNUKE ${MU_Echo}
	return false;
}

proc ::bonaPRE::undelpre { nick uhost hand chan arg } {
	set UD_Time 		"%Y-%m-%d %H:%M:%S"
	set UD_DateTime 	[clock format [clock seconds] -format $UD_Time] 
	set UD_Name     	[lindex ${arg} 0]
	set UD_Grp      	[lindex [split ${UD_Name} -] end]
	set UD_Raison   	[lindex ${arg} 1]
	set UD_Nukenet  	[lindex ${arg} 2]
	set UD_Echo		   	[lindex ${arg} 3]
	set UD_Chan 		${chan}
	::bonaPRE::nukexec ${nick} ${UD_Chan} ${UD_DateTime} ${UD_Name} ${UD_Grp} ${UD_Raison} ${UD_Nukenet} UNDELPRE ${UD_Echo}
	return false;
}

proc ::bonaPRE::unnuke { nick uhost hand chan arg } {
	set UN_Time 		"%Y-%m-%d %H:%M:%S"
	set UN_DateTime 	[clock format [clock seconds] -format $UN_Time] 
	set UN_Name     	[lindex ${arg} 0]
	set UN_Grp      	[lindex [split ${UN_Name} -] end]
	set UN_Raison   	[lindex ${arg} 1]
	set UN_Nukenet  	[lindex ${arg} 2]
	set UN_Echo		   	[lindex ${arg} 3]
	set UN_Chan 		${chan}
	::bonaPRE::nukexec ${nick} ${UN_Chan} ${UN_DateTime} ${UN_Name} ${UN_Grp} ${UN_Raison} ${UN_Nukenet} UNNUKE ${UN_Echo}
	return false;
}

proc ::bonaPRE::nukexec { args } {
	set EC_Nick [lindex ${args} 0]
	set EC_Chan [lindex ${args} 1]
	set EC_Time [lindex ${args} 2]
	set EC_Rls	[lindex ${args} 3]
	set EC_Grp	[lindex ${args} 4]
	set EC_Ra	[lindex ${args} 5]
	set EC_Nnet [lindex ${args} 6]
	set EC_Sta	[lindex ${args} 7]
	set EC_Ech	[lindex ${args} 8]
	if { ![channel get ${EC_Chan} bpnuke] } {
		set EC_LOGERR	[format "L'utilisateur %s à tenté un !%s sur %s, mais le salon n'a pas les *flags* necéssaire." ${EC_Nick} ${EC_Sta} ${EC_Chan}]
		set EC_MSGERR	[format "%s à tenté un !%s, mais le salon n'a pas les *flags* necéssaire." ${EC_Nick} ${EC_Sta}]
		putquick "privmsg ${EC_Chan} ${EC_MSGERR}"
		return -code error ${EC_LOGERR};
	}
	if { ${EC_Nnet} == "" } {
		set EC_LOGERR	[format "Syntax * %s à tenté un !%s sur %s, mais manque d'information..." ${EC_Nick} ${EC_Sta} ${EC_Chan}]
		set EC_MSGERR	[format "Syntax * !%s <nom.de.la.release> <raison> <nukenet>" ${EC_Sta}]
		putquick "privmsg ${EC_Chan} ${EC_MSGERR}"
		return -code error ${EC_LOGERR};
	}
	set EC_Sql       "INSERT INTO ${::bonaPRE::mysql_(dbnuke)} "
	append EC_Sql    "( `${::bonaPRE::nuke_(rlsname)}`, `${::bonaPRE::nuke_(group)}`, `${::bonaPRE::nuke_(datetime)}`, `${::bonaPRE::nuke_(nuke)}`, `${::bonaPRE::nuke_(raison)}`, `${::bonaPRE::nuke_(nukenet)}` ) ";
	append EC_Sql    "VALUES ( '${EC_Rls}', '${EC_Grp}', '${EC_Time}', '${EC_Sta}', '${EC_Ra}', '${EC_Nnet}' );";
	set EC_Sqld 	    [::mysql::exec ${::bonaPRE::mysql_(handle)} ${EC_Sql}];
	set EC_Sqlid [::mysql::insertid ${::bonaPRE::mysql_(handle)}]
	if {  ${EC_Sqld} == "1" } {
		if { ${EC_Ech} == "0" } {
			set EC_LOGOK	[format "Tcl exec \[::${::bonaPRE::VAR(release)}::NUKE\]: L'exécution de la requête %s pour %s (id: %s)" ${EC_Sqld} ${EC_Rls} ${EC_Sqlid}]
			putlog "${EC_LOGOK}"
			return false;
		} else {
			set EC_LOGOK	[format "Tcl exec \[::${::bonaPRE::VAR(release)}::NUKE\]: L'exécution de la requête %s pour %s (id: %s)" ${EC_Sqld} ${EC_Rls} ${EC_Sqlid}]
			set EC_MSGOK	[format "(%s) %s - %s / %s (%s)" ${EC_Sta} ${EC_Rls} ${EC_Ra} ${EC_Nnet} ${EC_Sqlid}]
			putquick "privmsg ${::bonaPRE::chan_(nuke)} ${EC_MSGOK}"
			putlog "${EC_LOGOK}"
			return false;
		}
	} else {
		set EC_LOGERR [format "La release %s n'a pas été ajoutée (WEiRD?!?) par %s/%s" ${EC_Rls} ${EC_Chan} ${EC_Nick}]
		set EC_MSGERR [format "%s n'a pas été ajoutée (WEiRD?!?)" ${EC_Rls}]
		putquick "privmsg ${EC_Chan} ${EC_MSGERR}"
		return -code error ${EC_LOGERR};
	}
}
package provide bonaPRE-NUKE 1.0
putlog "Tcl load \[::${::bonaPRE::VAR(release)}::NUKE\]: modTCL chargé."
