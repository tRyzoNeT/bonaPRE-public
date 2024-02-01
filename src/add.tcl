proc ::bonaPRE::addpre:init { args } {
	if { [catch { package require bonaPRE-SQL 1.0 }] } {
		set AE_LOGERR 	[format "${::bonaPRE::VAR(release)} modTCL * le fichier mysql.tcl doit être chargé avant add.tcl"]
		return -code error ${AE_LOGERR};
	}
}
::bonaPRE::addpre:init

bind pub -|- !addpre ::bonaPRE::addpre
bind pub -|- !addold ::bonaPRE::addold

proc ::bonaPRE::addpre { nick uhost hand chan arg } {
	set A_Time 		"%Y-%m-%d %H:%M:%S"
	set A_DateTime 	[clock format [clock seconds] -format $A_Time]
	set A_Name     	[lindex ${arg} 0]
	set A_Grp      	[lindex [split ${A_Name} -] end]
	set A_Sec   	[lindex ${arg} 1]
	set A_Echo	   	[lindex ${arg} 2]
	set A_Chan 		${chan}
	::bonaPRE::addexec ${nick} ${A_Chan} ${A_DateTime} ${A_DateTime} ${A_Name} ${A_Grp} ${A_Sec} ADDPRE ${A_Echo}
	return false;
}

proc ::bonaPRE::addold { nick uhost hand chan arg } {
	set O_UPTime 		"%Y-%m-%d %H:%M:%S"
	set O_UPDateTime 	[clock format [clock seconds] -format $O_UPTime]
	set O_Name     	[lindex ${arg} 0]
	set O_Grp      	[lindex [split ${O_Name} -] end]
	set O_Sec   	[lindex ${arg} 1]
	set O_DateTimeD	[lindex ${arg} 2]
	set O_DateTimeH [lindex ${arg} 3]
	set O_DateTime	"${O_DateTimeD} ${O_DateTimeH}";
	set O_Echo	   	[lindex ${arg} 4]
	set O_Chan 		${chan}
	::bonaPRE::addexec ${nick} ${O_Chan} ${O_DateTime} ${O_UPDateTime} ${O_Name} ${O_Grp} ${O_Sec} ADDOLD ${O_Echo}
	return false;
}

proc ::bonaPRE::addexec { args } {
	set AE_Nick  [lindex ${args} 0]
	set AE_Chan  [lindex ${args} 1]
	set AE_Time  [lindex ${args} 2]
	set AE_UTime [lindex ${args} 3]
	set AE_Rls	 [lindex ${args} 4]
	set AE_Grp	 [lindex ${args} 5]
	set AE_Sec	 [lindex ${args} 6]
	set AE_Sta	 [lindex ${args} 7]
	set AE_Ech	 [lindex ${args} 8]
	if { [getuser ${AE_Nick} XTRA uauth] == 1 } {
		if { ![channel get ${AE_Chan} bpadd] } {
			set AE_LOGERR	[format "L'utilisateur %s a tenté un !%s sur %s, mais le salon n'a pas les *flags* necéssaires." ${AE_Nick} ${AE_Sta} ${AE_Chan}]
			set AE_MSGERR	[format "%s à tenté un !%s, mais le salon n'a pas les *flags* necéssaires." ${AE_Nick} ${AE_Sta}]
			putquick "privmsg ${AE_Chan} ${AE_MSGERR}"
			return -code error ${AE_LOGERR};
		}
		if { ${AE_Sec} == "" } {
			set AE_LOGERR	[format "Syntax * %s a tenté un !%s sur %s, mais manque d'informations..." ${AE_Nick} ${AE_Sta} ${AE_Chan}]
			if { ${AE_Sta} == "ADDPRE" } { set AE_MSGERR	[format "Syntax * !%s <nom.de.la.release> <section>" ${AE_Sta}] }
			if { ${AE_Sta} == "ADDOLD" } { set AE_MSGERR	[format "Syntax * !%s <nom.de.la.release> <section> <datetime>" ${AE_Sta}] }
			putquick "privmsg ${AE_Chan} ${AE_MSGERR}"
			return -code error ${AE_LOGERR};
		}
		set AE_Sql       "INSERT IGNORE INTO ${::bonaPRE::mysql_(dbmain)} "
		append AE_Sql    "( `${::bonaPRE::db_(rlsname)}`, `${::bonaPRE::db_(group)}`, `${::bonaPRE::db_(section)}`, `${::bonaPRE::db_(datetime)}`, `${::bonaPRE::db_(lastupdated)}`, `${::bonaPRE::db_(status)}` ) ";
		append AE_Sql    "VALUES ( '${AE_Rls}', '${AE_Grp}', '${AE_Sec}', '${AE_Time}', '${AE_UTime}', '${AE_Sta}' );";
		set AE_Sqld			[::mysql::exec ${::bonaPRE::mysql_(handle)} ${AE_Sql}];
		set AE_Sqlid 		[::mysql::insertid ${::bonaPRE::mysql_(handle)}]
		if { ${AE_Sqld} == "1" } {
			if { ${AE_Ech} == "0" } {
				set AE_LOGOK	[format "Tcl exec \[::${::bonaPRE::VAR(release)}::${AE_Sta}\]: L'exécution de la requête %s pour %s (id: %s)" ${AE_Sqld} ${AE_Rls} ${AE_Sqlid}]
				putlog "${AE_LOGOK}"
				return false;
			} else {
				set AE_LOGOK	[format "Tcl exec \[::${::bonaPRE::VAR(release)}::${AE_Sta}\]: L'exécution de la requête %s pour %s (id: %s)" ${AE_Sqld} ${AE_Rls} ${AE_Sqlid}]
				set AE_MSGOK	[format "%s - %s (%s)" ${AE_Sec} ${AE_Rls} ${AE_Sqlid}]
				putquick "privmsg ${::bonaPRE::chan_(pred)} ${AE_MSGOK}"
				putlog "${AE_LOGOK}"
				return false;
			}
		} else {
			set AE_LOGERR [format "La release %s n'a pas été ajoutée (déjà existante?!?) par %s/%s" ${AE_Rls} ${AE_Chan} ${AE_Nick}]
			set AE_MSGERR [format "%s n'a pas été ajoutée (déjà existante?!?)" ${AE_Rls}]
			putquick "privmsg ${AE_Chan} ${AE_MSGERR}"
			return -code error ${AE_LOGERR};
		}
	} else {
			set AE_LOGERR 	[format "uAUTH * %s n'est pas iDENTiFiÉ au EGGDROP..." ${AE_Nick}]
			set AE_MSGERR	[format "uAUTH * Tu n'es pas iDENTiFiÉ au EGGDROP... CouCOU!!"]
  			putquick "privmsg ${AE_Chan} ${AE_MSGERR}"
  			return -code error ${AE_LOGERR};
	}
}
package provide bonaPRE-ADDPRE 1.0
putlog "Tcl load \[::${::bonaPRE::VAR(release)}::ADD\]: modTCL chargé."
