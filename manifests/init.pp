# == Define: homes
#
# Full description of definition homes here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
define homes (
$user,
$ssh_key
) {

	validate_re($osfamily, 'RedHat|Debian\b', "${::operatingsystem} not supported")
	validate_hash($user)
	validate_re($ssh_key, '[A-Za-z0-9]', "ssh_key can only contain upper or lowercase strings or numbers. ${ssh_key} is not valid")
	
	$username = keys($user)
	
	homes::config { "create home for ${username}":
	  user => $user,
	  ssh_key => $ssh_key
    }
}
