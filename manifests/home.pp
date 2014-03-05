# == Define Resource Type: homes::home
#
# This private definition will create the user and 
# manage the home directory
#
# === Parameters
#
# [*ensure*]
# Manage the presence of the user and home directory.
#
# [*user*]
# Hash, required parameter. If given the key-value pair will be used to create and
# manage the user.
#
define homes::home(
  $ensure = 'present',
  $user
) {

  $username = keys($user)

  if $ensure == 'present' {
    
	create_resources(user, $user)

    file { "/home/${username}":
      ensure => directory,
      owner  => $username,
      mode   => '0600'
    }
	
  } else {
    
	file { "/home/${username}":
      ensure => absent,
    }
	
  }
}
