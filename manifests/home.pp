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
  $user,
  $ensure = 'present'
) {

  $username = join(keys($user),',')

  # Deal with the case where certain groups don't exist on all OS versions
  case $::osfamily {
    'Debian': {
      $new_groups = delete(sub_item(sub_item($user, $username),'groups'),'wheel')
      $new_user = replace_hash($user,{ 'groups' => $new_groups })
    }
    'RedHat', 'Linux': {
      $new_groups = delete(sub_item(sub_item($user, $username),'groups'),'sudo')
      $new_user = replace_hash($user,{ 'groups' => $new_groups })
    }
    default: {
      $new_user = $user
    }
  }

  if $ensure == 'present' {

    create_resources(user, $new_user)

    file { "/home/${username}":
      ensure  => directory,
      owner   => $username,
      mode    => '0600'
    }

  } else {

    user { $username:
      ensure => absent
    }

    file { "/home/${username}":
      ensure => absent,
      force  => true,
      backup => false
    }

  }
}
