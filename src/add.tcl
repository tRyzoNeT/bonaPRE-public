
if { [catch { package require bonaPRE-SQL 1.1 }] } {
  set debugMessageOK            [format "%S modTCL * le fichier mysql.tcl doit être charger avant add.tcl" ${::bonaPRE::VAR(release)}]
  return -code error ${debugMessageOK};
}

bind pub -|- !addpre ::bonaPRE::addpre
bind pub -|- !addold ::bonaPRE::addold

proc ::bonaPRE::addpre { nickSource hostSource hand channelSource arg } {
  set releaseName               [lindex ${arg} 0]
  set groupName                 [lindex [split ${releaseName} -] end]
  set sectionName               [lindex ${arg} 1]
  ::bonaPRE::addexec ADDPRE ${nickSource} ${channelSource} ${currentDateTime} ${releaseName} ${groupName} ${sectionName} 
  return false;
}

proc ::bonaPRE::addold { nickSource hostSource hand channelSource arg } {
  
  set releaseName               [lindex ${arg} 0]
  set groupName                 [lindex [split ${releaseName} -] end]
  set sectionName               [lindex ${arg} 1]
  set datetimeDate              [lindex ${arg} 2]
  set datetimeHeure             [lindex ${arg} 3]
  set datetime                  "${datetimeDate} ${datetimeHeure}";
  ::bonaPRE::addexec ADDOLD ${nickSource} ${channelSource} ${datetime} ${releaseName} ${groupName} ${sectionName} 
  return false;
}

proc ::bonaPRE::addexec { commandName nickSource channelSource datetime releaseName groupName sectionName  } {
  set currentDateTime           [clock format [clock seconds] -format "%Y-%m-%d %H:%M:%S"]
  if { ![channel get ${channelSource} bpadd] } {
    set debugMessageOK          [format "L'utilisateur %s à tenté un !%s sur %s, mais le salon n'a pas les *flags* necéssaire." ${nickSource} ${commandName} ${channelSource}]
    set logMessageOK            [format "%s à tenté un !%s, mais le salon n'a pas les *flags* necéssaire." ${nickSource} ${commandName}]
    putquick "privmsg ${channelSource} ${logMessageOK}"
    return -code error ${debugMessageOK};
  }
  if { ${sectionName} == "" } {
    set debugMessageOK   [format "Syntax * %s à tenté un !%s sur %s, mais manque d'information..." ${nickSource} ${commandName} ${channelSource}]
    if { ${commandName} == "ADDPRE" } { set logMessageOK  [format "Syntax * !%s <nom.de.la.release> <section>" ${commandName}] }
    if { ${commandName} == "ADDOLD" } { set logMessageOK  [format "Syntax * !%s <nom.de.la.release> <section> <datetime>" ${commandName}] }
    putquick "privmsg ${channelSource} ${logMessageOK}"
    return -code error ${debugMessageOK};
  }
  set insertQuery               [format {
    INSERT INTO %s (
      `%s`, `%s`, `%s`, `%s`, `%s`, `%s`
    )}                                                                          \
      ${::bonaPRE::mysql_(dbmain)}                                              \
      ${::bonaPRE::db_(releaseName)}                                                \
      ${::bonaPRE::db_(group)}                                                  \
      ${::bonaPRE::db_(section)}                                                \
      ${::bonaPRE::db_(datetime)}                                               \
      ${::bonaPRE::db_(lastupdated)}                                            \
      ${::bonaPRE::db_(commandName)}];

  append insertQuery            [format {
    VALUES (
      '%s', '%s', '%s', '%s', '%s'
    );}                                                                         \
      [::mysql::escape [::bonaPRE::MySQL::getHandle] $releaseName]              \
      [::mysql::escape [::bonaPRE::MySQL::getHandle] $groupName]                \
      [::mysql::escape [::bonaPRE::MySQL::getHandle] $sectionName]              \
      [::mysql::escape [::bonaPRE::MySQL::getHandle] $datetime]                 \
      [::mysql::escape [::bonaPRE::MySQL::getHandle] $lastupdated]              \
      [::mysql::escape [::bonaPRE::MySQL::getHandle] $commandName]];

  set insertQueryStatus         [::bonaPRE::MySQL::exec ${insertQuery}];
  set insertQueryID             [::bonaPRE::MySQL::insertid]
  if { ${insertQueryStatus} == "1" } {
    set logError              [format "Tcl exec \[::${::bonaPRE::VAR(release)}::${commandName}\]: L'exécution de la requête %s pour %s (id: %s)" \
                                ${insertQueryStatus}                       \
                                ${releaseName}                                  \
                                ${insertQueryID}];
    set logMessage            [format "%s - %s (%s)" ${sectionName} ${releaseName} ${insertQueryID}]
    putquick "privmsg ${::bonaPRE::chan_(pred)} ${logMessage}"
    putlog "${logError}"
    return false;
  } else {
    set debugMessageOK        [format "La release %s n'a pas été ajoutée (déjà existante?!?) par %s/%s"                 \
                                ${releaseName}                                  \
                                ${channelSource}                                \
                                ${nickSource}]
    set logMessageOK            [format "%s n'a pas été ajoutée (déjà existante?!?)" ${releaseName}]
    putquick "privmsg ${channelSource} ${logMessageOK}"
    return -code error ${debugMessageOK};
  }
}
package provide bonaPRE-ADD 1.1
putlog "Tcl load \[::${::bonaPRE::VAR(release)}::ADD\]: modTCL chargé."
