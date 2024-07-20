
if { [catch { package require bonaPRE-SQL 1.0 }] } {
  set AI_LOGERR   [format "${::bonaPRE::VAR(release)} modTCL * le fichier mysql.tcl doit être charger avant url.tcl"]
  return -code error ${AI_LOGERR};
}


namespace eval ::bonaPRE {
  array set CMD     [list                                                       \
        "addurl"      "!addurl"                                                 \
        "addimdb"     "!addimdb"                                                \
        "addtvmaze"   "!addtvmaze"                                              \
  ];
}

bind pub -|- ${::bonaPRE::CMD(addurl)}    ::bonaPRE::urlADD
bind pub -|- ${::bonaPRE::CMD(addimdb)}   ::bonaPRE::urliMDB
bind pub -|- ${::bonaPRE::CMD(addtvmaze)} ::bonaPRE::urlTVMAZE

proc ::bonaPRE::urlADD { nickSource hostSource hand channelSource arg } {
  set UAD_Time      "%Y-%m-%d %H:%M:%S"
  set UAD_DateTime  [clock format [clock seconds] -format $UAD_Time]
  set UAD_Name      [lindex ${arg} 0]
  set UAD_Tvmaze    [lindex ${arg} 1]
  set UAD_Group     [lindex [split ${UAD_Name} -] end]
  set UAD_Chan      ${channelSource}
  ::bonaPRE::urlADDEXEC ${nickSource} ${UAD_Chan} ${UAD_DateTime} ${UAD_Tvmaze} ${UAD_Name} ${UAD_Group} ADDURL ${::bonaPRE::dburl_(addurl)}
  return false;
}

proc ::bonaPRE::urliMDB { nickSource hostSource hand channelSource arg } {
  set UIM_Time      "%Y-%m-%d %H:%M:%S"
  set UIM_DateTime  [clock format [clock seconds] -format $UIM_Time]
  set UIM_Name      [lindex ${arg} 0]
  set UIM_Tvmaze    [lindex ${arg} 1]
  set UIM_Group     [lindex [split ${UIM_Name} -] end]
  set UIM_Chan      ${channelSource}
  ::bonaPRE::urlADDEXEC ${nickSource} ${UIM_Chan} ${UIM_DateTime} ${UIM_Tvmaze} ${UIM_Name} ${UIM_Group} iMDB ${::bonaPRE::dburl_(imdb)}
  return false;
}

proc ::bonaPRE::urlTVMAZE { nickSource hostSource hand channelSource arg } {
  set UTM_Time      "%Y-%m-%d %H:%M:%S"
  set UTM_DateTime  [clock format [clock seconds] -format $UTM_Time]
  set UTM_Name      [lindex ${arg} 0]
  set UTM_Tvmaze    [lindex ${arg} 1]
  set UTM_Group     [lindex [split ${UTM_Name} -] end]
  set UTM_Chan      ${channelSource}
  ::bonaPRE::urlADDEXEC ${nickSource} ${UTM_Chan} ${UTM_DateTime} ${UTM_Tvmaze} ${UTM_Name} ${UTM_Group} TVMAZE ${::bonaPRE::dburl_(tvmaze)}
  return false;
}

proc ::bonaPRE::urlADDEXEC { args } {
  set UAE_Nick      [lindex ${args} 0]
  set UAE_Chan      [lindex ${args} 1]
  set UAE_Time      [lindex ${args} 2]
  set UAE_Var       [lindex ${args} 3]
  set UAE_Rls       [lindex ${args} 4]
  set UAE_Group     [lindex ${args} 5]
  set UAE_Sta       [lindex ${args} 6]
  set UAE_SQLTAG    [lindex ${args} 7]

  if { ${UAE_Sta} == "ADDURL" } { set UAE_StaTMP ${::bonaPRE::CMD(addurl)} }
  if { ${UAE_Sta} == "IMDB" } { set UAE_StaTMP ${::bonaPRE::CMD(addimdb)} }
  if { ${UAE_Sta} == "TVMAZE" } { set UAE_StaTMP ${::bonaPRE::CMD(addtvmaze)} }
  if { ![channel get ${UAE_Chan} bpurl] } {
    set UdebugMessageOK  [format "L'utilisateur %s à tenté un %s sur %s, mais le salon n'a pas les *flags* necéssaire." ${UAE_Nick} ${UAE_StaTMP} ${UAE_Chan}]
    set UlogMessageOK  [format "%s à tenté un %s, mais le salon n'a pas les *flags* necéssaire." ${UAE_Nick} ${UAE_StaTMP}]
    putquick "privmsg ${UAE_Chan} ${UlogMessageOK}"
    return -code error ${UdebugMessageOK};
  }
  if { ${UAE_Var} == "" } {
    if { ${UAE_Sta} == "ADDURL" } {
      set UdebugMessageOK  [format "Syntax * %s à tenté un %s sur %s, mais manque d'information..." ${UAE_Nick} ${::bonaPRE::CMD(addurl)} ${UAE_Chan}]
      set UlogMessageOK  [format "Syntax * %s <nom.de.la.release> <lien-url>" ${::bonaPRE::CMD(addurl)}]
      putquick "privmsg ${UAE_Chan} ${UlogMessageOK}"
      return -code error ${UdebugMessageOK};
    }
    if { ${UAE_Sta} == "iMDB" } {
      set UdebugMessageOK  [format "Syntax * %s à tenté un %s sur %s, mais manque d'information..." ${UAE_Nick} ${::bonaPRE::CMD(addimdb)} ${UAE_Chan}]
      set UlogMessageOK  [format "Syntax * %s <nom.de.la.release> <ttid-numero> *exemple: tt20256448*" ${::bonaPRE::CMD(addimdb)}]
      putquick "privmsg ${UAE_Chan} ${UlogMessageOK}"
      return -code error ${UdebugMessageOK};
    }
    if { ${UAE_Sta} == "TVMAZE" } {
      set UdebugMessageOK  [format "Syntax * %s à tenté un %s sur %s, mais manque d'information..." ${UAE_Nick} ${::bonaPRE::CMD(addtvmaze)} ${UAE_Chan}]
      set UlogMessageOK  [format "Syntax * %s <nom.de.la.release> <id-numero> *exemple: 76636*" ${::bonaPRE::CMD(addtvmaze)}]
      putquick "privmsg ${UAE_Chan} ${UlogMessageOK}"
      return -code error ${UdebugMessageOK};
    }
  }
  set UAE_Sql       "INSERT IGNORE INTO ${::bonaPRE::mysql_(dburl)} "
  append UAE_Sql    "( `${::bonaPRE::dburl_(releaseName)}`, `${::bonaPRE::dburl_(group)}`, `${::bonaPRE::dburl_(lastupdated)}`, `${UAE_SQLTAG}` ) ";
  append UAE_Sql    "VALUES ( '${UAE_Rls}', '${UAE_Group}', '${UAE_Time}', '${UAE_Var}' );";
  set UAE_Sqld      [::bonaPRE::MySQL::exec ${UAE_Sql}];
  set UAE_Sqlid     [::bonaPRE::MySQL::insertid]
  if { ${UAE_Sqld} == "0" } {
    set UAE_SqlUP     "UPDATE `${::bonaPRE::mysql_(dburl)}` ";
    append UAE_SqlUP  "SET `${::bonaPRE::dburl_(group)}`='${UAE_Group}', `${::bonaPRE::dburl_(lastupdated)}`='${UAE_Time}', `${UAE_SQLTAG}`='${UAE_Var}' ";
    append UAE_SqlUP  "WHERE `${::bonaPRE::dburl_(releaseName)}`='${UAE_Rls}';";
    set UAE_SqldUP    [::bonaPRE::MySQL::exec ${UAE_SqlUP}];
    set UAE_Sqldid1   "SELECT `${::bonaPRE::dburl_(id)}` FROM `${::bonaPRE::mysql_(dburl)}` WHERE `${::bonaPRE::db_(releaseName)}` LIKE '${UAE_Rls}%'";
    set UAE_Sqldid2   [::mysql::sel [::bonaPRE::MySQL::getHandle] ${UAE_Sqldid1} -flatlist];
    lassign  ${UAE_Sqldid2} UAE_SqlidOK;
    set UlogError     [format "Tcl exec \[::${::bonaPRE::VAR(release)}::${UAE_Sta}\]: L'exécution de la requête %s pour %s (id: %s)" ${UAE_SqldUP} ${UAE_Rls} ${UAE_SqlidOK}]
    set UlogMessage     [format "%s - %s %s (id: %s)" ${UAE_Sta} ${UAE_Rls} ${UAE_Var} ${UAE_SqlidOK}]
    putquick          "privmsg ${::bonaPRE::chan_(spam)} ${UlogMessage}"
    putlog "${UlogError}"
    return false;
  } else {
    set UlogError     [format "Tcl exec \[::${::bonaPRE::VAR(release)}::${UAE_Sta}\]: L'exécution de la requête %s pour %s (id: %s)" ${UAE_Sqld} ${UAE_Rls} ${UAE_Sqlid}]
    set UlogMessage     [format "%s - %s %s (id: %s)" ${UAE_Sta} ${UAE_Rls} ${UAE_Var} ${UAE_SqlidOK}]
    putquick          "privmsg ${::bonaPRE::chan_(spam)} ${UlogMessage}"
    putlog "${UlogError}"
    return false;
  }
}

package provide bonaPRE-ADDURL 1.1
putlog "Tcl load \[::${::bonaPRE::VAR(release)}::URL\]: modTCL chargé."
