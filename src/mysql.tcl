if { [catch { package require bonaPRE-CONF-PUBLiC 1 }] } { die "${::bonaPRE::VAR(release)} modTCL * le fichier configuration.tcl doit être charger avant mysql.tcl" ; return }
putlog "Tcl load \[::${::bonaPRE::VAR(release)}::MySQL\]: modTCL chargé."

proc ::bonaPRE::MySQL:KeepAlive { } {
	if { ![info exists ::bonaPRE::mysql_(handle)] || [mysql::state ${::bonaPRE::mysql_(handle)} -numeric] == 0 || ![mysql::ping ${::bonaPRE::mysql_(handle)}] } {
		if { [catch { set ::bonaPRE::mysql_(handle) [::mysql::connect -multistatement 1 -host ${::bonaPRE::mysql_(host)} -user ${::bonaPRE::mysql_(user)} -password ${::bonaPRE::mysql_(password)} -db ${::bonaPRE::mysql_(db)}] } MYSQL_ERR] } {
			if { [string match "*Access*denied*" ${MYSQL_ERR}] } {
				putlog "Tcl error \[::${::bonaPRE::VAR(release)}::MySQL\]: vérifier les informations MySQL."
				utimer ${::bonaPRE::mysql_(conrefresh)} [list ::bonaPRE::MySQL:KeepAlive]
				return false;
			} else {
				putlog "Tcl error \[::${::bonaPRE::VAR(release)}::MySQL\]: SQL FATAL \[::mysql::connect):\] ${MYSQL_ERR}"
				utimer ${::bonaPRE::mysql_(conrefresh)} [list ::bonaPRE::MySQL:KeepAlive]
				return false;
			}
		}
		putlog "Tcl exec \[::${::bonaPRE::VAR(release)}::MySQL\]: Connexion avec success. 'KEEPALiVE' \[${::bonaPRE::mysql_(handle)}\]"
		utimer ${::bonaPRE::mysql_(conrefresh)} [list ::bonaPRE::MySQL:KeepAlive]
		return false;
	}
	if { [string match "*Server*has*gone*away*" ${::bonaPRE::mysql_(handle)}] } {
		set ::bonaPRE::mysql_(handle) [::mysql::connect -multistatement 1 -host ${::bonaPRE::mysql_(host)} -user ${::bonaPRE::mysql_(user)} -password ${::bonaPRE::mysql_(password)} -db ${::bonaPRE::mysql_(db)}]
		putlog "Tcl exec \[::${::bonaPRE::VAR(release)}::MySQL\]: Connexion avec success. 'KEEPALiVE' (BACK GONE AWAY) \[${::bonaPRE::mysql_(handle)}\]"
		utimer ${::bonaPRE::mysql_(conrefresh)} [list ::bonaPRE::MySQL:KeepAlive]
		return false;
	} 
	putlog "Tcl exec \[::${::bonaPRE::VAR(release)}::MySQL\]: Connexion STABLE. 'KEEPALiVE' \[${::bonaPRE::mysql_(handle)}\]"
	utimer ${::bonaPRE::mysql_(conrefresh)} [list ::bonaPRE::MySQL:KeepAlive]
	return false;
}

::bonaPRE::MySQL:KeepAlive 
package provide bonaPRE-SQL 1.0
