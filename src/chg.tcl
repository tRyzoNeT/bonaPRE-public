proc ::bonaPRE::CHG:init { args } {
	if { [catch { package require bonaPRE-SQL 1.0 }] } {
		set AE_LOGERR 	[format "${::bonaPRE::VAR(release)} modTCL * le fichier mysql.tcl doit être chargé avant chg.tcl"]
		return -code error ${AE_LOGERR};
	}
}
::bonaPRE::CHG:init

namespace eval CHG {
 variable SEC "!chgsec";
 variable TiME "!chgtime";
 variable FiLE "!chgfile";
 variable SiZE "!chgsize";
}

bind pub -|- ${::CHG::SEC} ::bonaPRE::chgsec
bind pub -|- ${::CHG::TiME} ::bonaPRE::chgtime
bind pub -|- ${::CHG::FiLE} ::bonaPRE::chgfile
bind pub -|- ${::CHG::SiZE} ::bonaPRE::chgsize

proc ::bonaPRE::chgsec { nick uhost hand chan arg } {
	set CHGS_Time 		"%Y-%m-%d %H:%M:%S"
	set CHGS_DateTime 	[clock format [clock seconds] -format $CHGS_Time]
	set CHGS_Name     	[lindex ${arg} 0]
	set CHGS_Var   		[lindex ${arg} 1]
	set CHGS_Echo	   	[lindex ${arg} 2]
	if { [getuser ${nick} XTRA uauth] == 1 } {
		if { ![channel get ${chan} bpadd] } {
			set CHGS_LOGERR		[format "L'utilisateur %s a tenté un %s sur %s, mais le salon n'a pas les *flags* necéssaires." ${nick} ${::CHG::SEC} ${chan}]
			set CHGS_MSGERR	[format "%s a tenté un %s, mais le salon n'a pas les *flags* necéssaires." ${nick} ${::CHG::SEC}]
			putquick "privmsg ${chan} ${CHGS_MSGERR}"
			return -code error ${CHGS_LOGERR};
		}
		if { ${CHGS_Var} == "" } {
			set CHGS_LOGERR	[format "Syntax * %s a tenté un %s sur %s, mais manque d'informations..." ${nick} ${::CHG::SEC} ${chan}]
			set CHGS_MSGERR	[format "Syntax * %s <nom.de.la.release> <section>" ${::CHG::SEC}]
			putquick "privmsg ${chan} ${CHGS_MSGERR}"
			return -code error ${CHGS_LOGERR};
		}
		if { ${CHGS_Echo} == "0" } {
			set CHGS_SqlUP      	"UPDATE `${::bonaPRE::mysql_(dbmain)}` ";
			append CHGS_SqlUP   	"SET `${::bonaPRE::db_(lastupdated)}`='${CHGS_DateTime}', `${::bonaPRE::db_(section)}`='${CHGS_Var}' ";
			append CHGS_SqlUP   	"WHERE `${::bonaPRE::db_(rlsname)}`='${CHGS_Name}';";
			set CHGS_SqldUP		[::mysql::exec ${::bonaPRE::mysql_(handle)} ${CHGS_SqlUP}];
			set CHGS_Sqldid1		"SELECT `${::bonaPRE::db_(id)}` FROM `${::bonaPRE::mysql_(dbmain)}` WHERE `${::bonaPRE::db_(rlsname)}` LIKE '${CHGS_Name}%'";
			set CHGS_Sqldid2		[::mysql::sel ${::bonaPRE::mysql_(handle)} ${CHGS_Sqldid1} -flatlist];
			lassign  ${CHGS_Sqldid2} CHGS_SqlidOK;
			set CHGS_LOGOK		[format "Tcl exec \[::${::bonaPRE::VAR(release)}::${::CHG::SEC}\]: L'exécution de la requête %s pour %s (id: %s)" ${CHGS_SqldUP} ${CHGS_Name} ${CHGS_SqlidOK}]
			putlog "${CHGS_LOGOK}"
			return false;
		} else {
			set CHGS_SqlUP      	"UPDATE `${::bonaPRE::mysql_(dbmain)}` ";
			append CHGS_SqlUP   	"SET `${::bonaPRE::db_(lastupdated)}`='${CHGS_DateTime}', `${::bonaPRE::db_(section)}`='${CHGS_Var}' ";
			append CHGS_SqlUP   	"WHERE `${::bonaPRE::db_(rlsname)}`='${CHGS_Name}';";
			set CHGS_SqldUP		[::mysql::exec ${::bonaPRE::mysql_(handle)} ${CHGS_SqlUP}];
			set CHGS_Sqldid1		"SELECT `${::bonaPRE::db_(id)}` FROM `${::bonaPRE::mysql_(dbmain)}` WHERE `${::bonaPRE::db_(rlsname)}` LIKE '${CHGS_Name}%'";
			set CHGS_Sqldid2		[::mysql::sel ${::bonaPRE::mysql_(handle)} ${CHGS_Sqldid1} -flatlist];
			lassign  ${CHGS_Sqldid2} CHGS_SqlidOK;
			set CHGS_LOGOK		[format "Tcl exec \[::${::bonaPRE::VAR(release)}::${::CHG::SEC}\]: L'exécution de la requête %s pour %s (id: %s)" ${CHGS_SqldUP} ${CHGS_Name} ${CHGS_SqlidOK}]
			set CHGS_MSGOK		[format "%s - %s (id: %s)" ${CHGS_Var} ${CHGS_Name} ${CHGS_SqlidOK}]
			putquick "privmsg ${::bonaPRE::chan_(spam)} ${CHGS_MSGOK}"
			putlog "${CHGS_LOGOK}"
			return false;
		}
	} else {
		set CHGS_LOGERR	[format "uAUTH * %s n'est pas iDENTiFiÉ au EGGDROP..." ${nick}]
		set CHGS_MSGERR	[format "uAUTH * Tu n'es pas iDENTiFiÉ au EGGDROP... CouCOU!!"]
  		putquick "privmsg ${chan} ${CHGS_MSGERR}"
  		return -code error ${CHGS_LOGERR};
	}
}

package provide bonaPRE-CHG 1.0
putlog "Tcl load \[::${::bonaPRE::VAR(release)}::CHG\]: modTCL chargé."
