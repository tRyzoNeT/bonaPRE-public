proc ::bonaPRE::pre:init { args } {
  if { [catch { package require bonaPRE-SQL 1.1 }] } {
    set AE_LOGERR   [format "${::bonaPRE::VAR(release)} modTCL * le fichier mysql.tcl doit être charger avant pre.tcl"]
    return -code error ${AE_LOGERR};
  }
}
::bonaPRE::pre:init

bind pub -|- !pre ::bonaPRE::pre

proc ::bonaPRE::pre { nick uhost hand chan arg } {
  set P_Rlsname     [lindex ${arg} 0]
  if { ![channel get ${chan} bpsearch] } {
    set P_LOGERR    [format "L'utilisateur %s à tenté un !pre sur %s, mais le salon n'a pas les *flags* necéssaire." ${nick} ${chan}]
    set P_MSGERR    [format "%s à tenté un !pre, mais le salon n'a pas les *flags* necéssaire." ${nick}]
    putquick "privmsg ${chan} ${P_MSGERR}"
    return -code error ${P_LOGERR};
  }
  if { ${P_Rlsname} == "" } {
    set P_LOGERR    [format "Syntax * %s à tenté un !pre sur %s, mais manque d'information..." ${nick} ${chan}]
    set P_MSGERR    [format "Syntax * !pre <nom.de.la.release>"]
    putquick "privmsg ${chan} ${P_MSGERR}"
    return -code error ${P_LOGERR};
  }
  set P_Sql         "SELECT `${::bonaPRE::db_(id)}`, `${::bonaPRE::db_(rlsname)}`, `${::bonaPRE::db_(section)}`, `${::bonaPRE::db_(datetime)}`, `${::bonaPRE::db_(files)}`, `${::bonaPRE::db_(size)}`";
  append P_Sql      "FROM `${::bonaPRE::mysql_(dbmain)}` ";
  append P_Sql      "WHERE `${::bonaPRE::db_(rlsname)}` LIKE '${P_Rlsname}%' ";
  append P_Sql      "ORDER BY ${::bonaPRE::db_(datetime)} DESC LIMIT 1;";
  set P_Sqld        [::mysql::sel ${::bonaPRE::mysql_(handle)} ${P_Sql} -flatlist];
  if { ${P_Sqld} != "" } {
    # (lassign) La Liste SQL separer en variables https://www.tcl.tk/man/tcl8.7/TclCmd/lassign.html
    lassign ${P_Sqld} P_Id P_Rls P_Section P_Datetime P_Files P_Size;
    set P_CTIME     [clock scan "${P_Datetime}"]
    set P_UTIME     [unixtime]
    set P_AGO       [duration [expr {${P_CTIME} - ${P_UTIME}}]]
    set P_MSGOK1    [format "\002\0033(\0037PRE\0033)\002\0037 ${P_Rls} \0033-\00315\002 ${P_Section} \002\0033(\0037id:\0038 ${P_Id}\0033)"]
    set P_MSGOK2    [format "\002\0033(\0037DateTiME\0033)\002\00310 ${P_Datetime} - ${P_CTIME} - ${P_AGO}"]
    putquick "privmsg ${chan} ${P_MSGOK1}"
    putquick "privmsg ${chan} ${P_MSGOK2}"
    if { ${P_Size} == "" } { } else { 
      set P_MSGOK3  [format "\002\0033(\0037iNFO\0033)\002\0038 ${P_Files} \00310fichier \0033|\00311 ${P_Size} \0037mb "]
      putquick "privmsg ${chan} ${P_MSGOK3}"
    }
    ::bonaPRE::preurl ${P_Rls} ${chan}
    return false;
  } else {
      set P_MSGERR  [format "\002\0033(\0037PRE\0033)\002\0037 ${P_Rlsname} \00315inexistant dans la database."]
      putquick "privmsg ${chan} ${P_MSGERR}"
    return false;
  }
}

proc ::bonaPRE::preurl { args } {
  set PU_Rlsname    [lindex ${args} 0]
  set PU_Chan       [lindex ${args} 1]
  set PU_Sql        "SELECT `${::bonaPRE::dburl_(rlsname)}`, `${::bonaPRE::dburl_(addurl)}`, `${::bonaPRE::dburl_(imdb)}`, `${::bonaPRE::dburl_(tvmaze)}`";
  append PU_Sql     "FROM `${::bonaPRE::mysql_(dburl)}` ";
  append PU_Sql     "WHERE `${::bonaPRE::dburl_(rlsname)}` LIKE '${PU_Rlsname}%' ;";
  set PU_Sqld       [::mysql::sel ${::bonaPRE::mysql_(handle)} ${PU_Sql} -flatlist];
  if { ${PU_Sqld} != "" } {
    # (lassign) La Liste SQL separer en variables https://www.tcl.tk/man/tcl8.7/TclCmd/lassign.html
    lassign ${PU_Sqld} PU_Rls PU_Addurl PU_Imdb PU_Tvmaze;
    if { ${PU_Addurl} == "" } { } else {
      set PU_MSGOK1 [format "\002\0033(\0037Url\0033)\002\00310 ${PU_Addurl}"]
      putquick "privmsg ${PU_Chan} ${PU_MSGOK1}"
    }
    if { ${PU_Tvmaze} == "" } { } else {
      set PU_MSGOK2 [format "\002\0033(\0037TVmaze\0033)\002\00310 ${::bonaPRE::url_(tvmaze)}${PU_Tvmaze}"]
      putquick "privmsg ${PU_Chan} ${PU_MSGOK2}"
    }
    if { ${PU_Imdb} == "" } { } else {
      set PU_MSGOK3 [format "\002\0033(\0037iMDB\0033)\002\00310 ${::bonaPRE::url_(imdb)}${PU_Imdb}"]
      putquick "privmsg ${PU_Chan} ${PU_MSGOK3}"
    }
  } else { return false; }
}

package provide bonaPRE-PRE-PUBLiC 1.1
putlog "Tcl load \[::${::bonaPRE::VAR(release)}::PRE\]: modTCL chargé."
