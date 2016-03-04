# Author::    Liam Bennett  (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Define Resource Type: homes::ssh::public
#
# This private definition will manage the public key for a given user
#
# === Parameters
#
# [*username*]
# String, required parameter. The name of the user that will be managed.
#
# [*ssh_key*]
# String, default empty. If given, this will be used to populate the authorized_keys
# file for the given user.
#
# === Examples
#
# Manage the authorized_key for a given user:
#
# homes::ssh::public { 'id_rsa.pub for testuser'
#  username => 'testuser',
#  ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAAAgQC4U/G9Idqy1VvYEDCKg3noVChCbIrJAi0D/qMFoG=='
# }
#
define homes::ssh::public(
  $username,
  $home,
  $ssh_key,
  $ssh_key_type,
  $ssh_key_options = undef,
  $ensure = 'present'
) {

  if "x${home}x" == 'xx' {
    $homedir = "/home/${username}"
  } else {
    $homedir = $home
  }

  if $ensure == 'present' {
    file { "${homedir}/.ssh":
      ensure  => directory,
      owner   => $username,
      mode    => '0600',
      require => File[$homedir]
    }

    ssh_authorized_key { $username:
      ensure  => present,
      key     => $ssh_key,
      target  => "${homedir}/.ssh/authorized_keys",
      type    => $ssh_key_type,
      user    => $username,
      options => $ssh_key_options,
      require => File["${homedir}/.ssh"]
    }

    file { "${homedir}/.ssh/authorized_keys":
      ensure => present,
      owner  => $username,
      mode   => '0600'
    }
  } else {
    file { "${homedir}/.ssh":
      ensure => absent,
      force  => true,
      backup => false
    }
  }
}
