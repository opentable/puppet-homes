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
$ssh_key=''
) {

	validate_re($osfamily, 'RedHat|Debian\b', "${::operatingsystem} not supported")
	validate_hash($user)
	
	$username = keys($user)
	
	homes::home { "create home for ${username}":
	  user => $user
    }
	
	if $ssh_key != '' {
	  validate_re($ssh_key, '[A-Za-z0-9]', "ssh_key can only contain upper or lowercase strings or numbers. ${ssh_key} is not valid")	
		
	  homes::ssh::public { "auth_keys for ${username}":
		username => $username,
		ssh_key  => $ssh_key
	  }
	}
}
