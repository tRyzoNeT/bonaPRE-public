# Vérifie si le package 'bonaPRE-SQL' version 1.0 est disponible, sinon, envoie une erreur
if { [catch { package require bonaPRE-SQL 1.0 }] } { 
  set logError [format "%s modTCL * le fichier mysql.tcl doit être chargé avant del.tcl" ${::bonaPRE::VAR(release)}]
  return -code error ${logError};
}

# Liaison des commandes IRC aux procédures Tcl correspondantes
correspondantes
bind pub -|- !olddelpre         ::bonaPRE::OldDelPre
bind pub -|- !oldmoddelpre      ::bonaPRE::OldModDelPre
bind pub -|- !oldundelpre       ::bonaPRE::OldUndelPre
bind pub -|- !delpre            ::bonaPRE::DelPre
bind pub -|- !moddelpre         ::bonaPRE::ModDelPre
bind pub -|- !undelpre          ::bonaPRE::UndelPre

# Procédure pour gérer la commande !delpre
proc ::bonaPRE::DelPre { nickSource hostSource hand channelSource arg } {
  set currentDateTime           [clock format [clock seconds] -format "%Y-%m-%d %H:%M:%S"] 
  set releaseName               [lindex ${arg} 0]
  set groupName                 [lindex [split ${releaseName} -] end]
  set delReason                 [lindex ${arg} 1]
  set delNet                    [lindex ${arg} 2]
  set needEcho                  [lindex ${arg} 3]

  # Appel de la procédure d'exécution de suppression
  return [::bonaPRE::delexec ${nickSource} ${channelSource} ${currentDateTime} ${releaseName} ${groupName} ${delReason} ${delNet} DELPRE ${needEcho}]
}

# Procédure pour gérer la commande !moddelpre
proc ::bonaPRE::ModDelPre { nickSource hostSource hand channelSource arg } {
  set currentDateTime           [clock format [clock seconds] -format "%Y-%m-%d %H:%M:%S"] 
  set releaseName               [lindex ${arg} 0]
  set groupName                 [lindex [split ${releaseName} -] end]
  set delReason                 [lindex ${arg} 1]
  set delNet                    [lindex ${arg} 2]
  set needEcho                  [lindex ${arg} 3]

  # Appel de la procédure d'exécution de modification de suppression
  return [::bonaPRE::delexec ${nickSource} ${channelSource} ${currentDateTime} ${releaseName} ${groupName} ${delReason} ${delNet} MODDELPRE ${needEcho}]
}

# Procédure pour gérer la commande !undelpre
proc ::bonaPRE::UndelPre { nickSource hostSource hand channelSource arg } {
  set currentDateTime           [clock format [clock seconds] -format "%Y-%m-%d %H:%M:%S"] 
  set releaseName               [lindex ${arg} 0]
  set groupName                 [lindex [split ${releaseName} -] end]
  set delReason                 [lindex ${arg} 1]
  set delNet                    [lindex ${arg} 2]
  set needEcho                  [lindex ${arg} 3]

  # Appel de la procédure d'exécution d'annulation de suppression
  return [::bonaPRE::delexec ${nickSource} ${channelSource} ${currentDateTime} ${releaseName} ${groupName} ${delReason} ${delNet} UNDELPRE ${needEcho}]
}

# Procédure pour gérer les anciennes commandes !olddelpre
proc ::bonaPRE::OldDelPre { nickSource hostSource hand channelSource arg } {
  set releaseName               [lindex ${arg} 0]
  set groupName                 [lindex [split ${releaseName} -] end]
  set delReason                 [lindex ${arg} 1]
  set delNet                    [lindex ${arg} 2]
  set oldDate                   [lindex ${arg} 3]
  set oldDateTimeFormat         [lindex ${arg} 4]
  set needEcho                  [lindex ${arg} 5]

  # Appel de la procédure d'exécution de suppression ancienne
  return [::bonaPRE::delexec ${nickSource} ${channelSource} ${oldDate} ${oldDateTimeFormat} ${releaseName} ${groupName} ${delReason} ${delNet} DELPRE ${needEcho}]
}

# Procédure pour gérer les anciennes commandes !oldmoddelpre
proc ::bonaPRE::OldModDelPre { nickSource hostSource hand channelSource arg } {
  set releaseName               [lindex ${arg} 0]
  set groupName                 [lindex [split ${releaseName} -] end]
  set delReason                 [lindex ${arg} 1]
  set delNet                    [lindex ${arg} 2]
  set oldModDate                [lindex ${arg} 3]
  set oldModDateTimeFormat      [lindex ${arg} 4]
  set needEcho                  [lindex ${arg} 5]

  # Appel de la procédure d'exécution de modification de suppression ancienne
  return [::bonaPRE::delexec ${nickSource} ${channelSource} ${oldModDate} ${oldModDateTimeFormat} ${releaseName} ${groupName} ${delReason} ${delNet} MODDELPRE ${needEcho}]
}

# Procédure principale d'exécution des suppressions et modifications
proc ::bonaPRE::DelExec { args } {
  set nickSource                [lindex ${args} 0]
  set channelSource             [lindex ${args} 1]
  set dateTimeSource            [lindex ${args} 2]
  set releaseName               [lindex ${args} 3]
  set groupName                 [lindex ${args} 4]
  set delReason                 [lindex ${args} 5]
  set delNet                    [lindex ${args} 6]
  set commandName               [lindex ${args} 7]
  set needEcho                  [lindex ${args} 8]

  # Vérification des permissions de canal
  if { ![channel get ${channelSource} bpdel] } {
    set logError                [format "L'utilisateur %s a tenté un !%s sur %s, mais le salon n'a pas les *flags* nécessaires." \
                                        ${nickSource}                           \
                                        ${commandName}                            \
                                        ${channelSource}]
    set logMessage              [format "%s a tenté un !%s, mais le salon n'a pas les *flags* nécessaires." \
                                        ${nickSource}                           \
                                        ${commandName}]
    putquick "privmsg ${channelSource} ${logMessage}"
    return -code error ${logError};
  }

  # Vérification des informations de suppression
  if { ${delNet} == "" } {
    set logError                [format "Syntax * %s a tenté un !%s sur %s, mais manque d'information..." \
                                        ${nickSource}                           \
                                        ${commandName}                            \
                                        ${channelSource}]
    set logMessage              [format "Syntax * !%s <nom.de.la.release> <raison> <nukenet>" ${commandName}]
    putquick "privmsg ${channelSource} ${logMessage}"
    return -code error ${logError};
  }

  set insertQuery               [format {
    INSERT INTO %s (
      `%s`, `%s`, `%s`, `%s`, `%s`, `%s`
    )}                                                                          \
      ${::bonaPRE::mysql_(dbdel)}                                               \
      ${::bonaPRE::del_(releaseName)}                                           \
      ${::bonaPRE::del_(group)}                                                 \
      ${::bonaPRE::del_(datetime)}                                              \
      ${::bonaPRE::del_(typeName)}                                              \
      ${::bonaPRE::del_(reasonMessage)}                                         \
      ${::bonaPRE::del_(delNetName)}];

  append insertQuery            [format {
    VALUES (
      '%s', '%s', '%s', '%s', '%s', '%s'
    );}                                                                         \
      [::mysql::escape [::bonaPRE::MySQL::getHandle] $releaseName]                                                      \
      [::mysql::escape [::bonaPRE::MySQL::getHandle] $groupName]                                                        \
      [::mysql::escape [::bonaPRE::MySQL::getHandle] $dateTimeSource]                                                   \
      [::mysql::escape [::bonaPRE::MySQL::getHandle] $commandName]                                                        \
      [::mysql::escape [::bonaPRE::MySQL::getHandle] $delReason]                                                        \
      [::mysql::escape [::bonaPRE::MySQL::getHandle] $delNet]];

  set insertQueryStatus         [::bonaPRE::MySQL::exec ${insertQuery}];
  set insertQueryID             [::bonaPRE::MySQL::insertid]
  if {  ${insertQueryStatus} != "1" } {
    set logError                [format "La release %s n'a pas été ajoutée (WEiRD?!?) par %s/%s" \
                                        ${releaseName}                          \
                                        ${channelSource}                        \
                                        ${nickSource}]
    set logMessage              [format "%s n'a pas été ajoutée (WEiRD?!?)" ${releaseName}]
    putquick "privmsg ${channelSource} ${logMessage}"
    return -code error ${logError};
  }
  set debugMessageOK            [format "Tcl exec \[::%s::NUKE\]: L'exécution de la requête %s pour %s (id: %s)" \
                                    ${::bonaPRE::VAR(release)}                  \
                                    ${insertQueryStatus}                        \
                                    ${releaseName}                              \
                                    ${insertQueryID}]

  set logMessageOK              [format "(%s) %s - %s / %s (%s)"                \
                                        ${commandName}                          \
                                        ${releaseName}                          \
                                        ${delReason}                            \
                                        ${delNet}                               \
                                        ${insertQueryID}]
  if { ${needEcho} } { putquick "privmsg ${::bonaPRE::chan_(nuke)} ${logMessageOK}" }
  putlog ${debugMessageOK}
  return true;
}

package provide bonaPRE-DELPRE 1.0
putlog "Tcl load \[::${::bonaPRE::VAR(release)}::DELPRE\]: modTCL chargé."
