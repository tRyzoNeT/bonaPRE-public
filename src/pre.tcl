
if { [catch { package require bonaPRE-SQL 1.1 }] } {
  set debugMessageOK   [format "${::bonaPRE::VAR(release)} modTCL * le fichier mysql.tcl doit être charger avant pre.tcl"]
  return -code error ${debugMessageOK};
}


bind pub -|- !pre ::bonaPRE::pre

proc ::bonaPRE::pre { nickSource hostSource hand channelSource arg } {
  set P_releaseName     [lindex ${arg} 0]
  if { ![channel get ${channelSource} bpsearch] } {
    set P_LOGERR    [format "L'utilisateur %s à tenté un !pre sur %s, mais le salon n'a pas les *flags* necéssaire." ${nickSource} ${channelSource}]
    set P_MSGERR    [format "%s à tenté un !pre, mais le salon n'a pas les *flags* necéssaire." ${nickSource}]
    putquick "privmsg ${channelSource} ${P_MSGERR}"
    return -code error ${P_LOGERR};
  }
  if { ${P_releaseName} == "" } {
    set P_LOGERR    [format "Syntax * %s à tenté un !pre sur %s, mais manque d'information..." ${nickSource} ${channelSource}]
    set P_MSGERR    [format "Syntax * !pre <nom.de.la.release>"]
    putquick "privmsg ${channelSource} ${P_MSGERR}"
    return -code error ${P_LOGERR};
  }
  set P_Sql         "SELECT `${::bonaPRE::db_(id)}`, `${::bonaPRE::db_(releaseName)}`, `${::bonaPRE::db_(section)}`, `${::bonaPRE::db_(datetime)}`, `${::bonaPRE::db_(files)}`, `${::bonaPRE::db_(size)}`";
  append P_Sql      "FROM `${::bonaPRE::mysql_(dbmain)}` ";
  append P_Sql      "WHERE `${::bonaPRE::db_(releaseName)}` LIKE '${P_releaseName}%' ";
  append P_Sql      "ORDER BY ${::bonaPRE::db_(datetime)} DESC LIMIT 1;";
  set P_Sqld        [::mysql::sel [::bonaPRE::MySQL::getHandle] ${P_Sql} -flatlist];
  if { ${P_Sqld} != "" } {
    # (lassign) La Liste SQL separer en variables https://www.tcl.tk/man/tcl8.7/TclCmd/lassign.html
    lassign ${P_Sqld} P_Id P_Rls P_Section P_Datetime P_Files P_Size;
    set P_CTIME     [clock scan "${P_Datetime}"]
    set P_UTIME     [unixtime]
    set P_AGO       [duration [expr {${P_CTIME} - ${P_UTIME}}]]
    set P_MSGOK1    [format "\002\0033(\0037PRE\0033)\002\0037 ${P_Rls} \0033-\00315\002 ${P_Section} \002\0033(\0037id:\0038 ${P_Id}\0033)"]
    set P_MSGOK2    [format "\002\0033(\0037DateTiME\0033)\002\00310 ${P_Datetime} - ${P_CTIME} - ${P_AGO}"]
    putquick "privmsg ${channelSource} ${P_MSGOK1}"
    putquick "privmsg ${channelSource} ${P_MSGOK2}"
    if { ${P_Size} == "" } { } else { 
      set P_MSGOK3  [format "\002\0033(\0037iNFO\0033)\002\0038 ${P_Files} \00310fichier \0033|\00311 ${P_Size} \0037mb "]
      putquick "privmsg ${channelSource} ${P_MSGOK3}"
    }
    ::bonaPRE::preurl ${P_Rls} ${channelSource}
    return false;
  } else {
      set P_MSGERR  [format "\002\0033(\0037PRE\0033)\002\0037 ${P_releaseName} \00315inexistant dans la database."]
      putquick "privmsg ${channelSource} ${P_MSGERR}"
    return false;
  }
}

proc ::bonaPRE::preurl { args } {
  set PU_releaseName    [lindex ${args} 0]
  set PU_Chan       [lindex ${args} 1]
  set PU_Sql        "SELECT `${::bonaPRE::dburl_(releaseName)}`, `${::bonaPRE::dburl_(addurl)}`, `${::bonaPRE::dburl_(imdb)}`, `${::bonaPRE::dburl_(tvmaze)}`";
  append PU_Sql     "FROM `${::bonaPRE::mysql_(dburl)}` ";
  append PU_Sql     "WHERE `${::bonaPRE::dburl_(releaseName)}` LIKE '${PU_releaseName}%' ;";
  set PU_Sqld       [::mysql::sel [::bonaPRE::MySQL::getHandle] ${PU_Sql} -flatlist];
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
