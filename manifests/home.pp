# Author::    Liam Bennett  (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

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
  $username,
  $user,
  $ensure = 'present'
) {

  if has_key($user, 'home') {
    $home_dir = $user['home']
  } else {
    $home_dir = "/home/${username}"
  }

  # Squash groups hash into array.
  # Hiera does not support deep merging arrays so we need to have groups specified
  # as a hash and they squash it into an array for use by the user resource.
  $old_groups = sub_item($user, 'groups')

  if $old_groups {
    if is_hash($old_groups) {
      $group_array = sort(keys($old_groups))
    } else {
      $group_array = sort($old_groups)
    }

    # Deal with the case where certain groups don't exist on all OS versions
    case $::osfamily {
      'Debian': {
        $new_groups = delete($group_array, 'wheel')
      }
      'RedHat', 'Linux': {
        $new_groups = delete($group_array, 'sudo')
      }
      default: {
        $new_groups = $group_array
      }
    }

    $new_user = { "${username}" => replace_hash($user, { 'groups' => $new_groups }) }
  } else {
    $new_user = { "${username}" => $user }
  }



  if $ensure == 'present' {

    create_resources(user, $new_user)

    file { $home_dir:
      ensure => directory,
      owner  => $username,
      mode   => '0600'
    }

  } else {

    user { $username:
      ensure => absent
    }

    file { $home_dir:
      ensure => absent,
      force  => true,
      backup => false
    }

  }
}
