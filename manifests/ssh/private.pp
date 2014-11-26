# Author::    Liam Bennett  (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Define Resource Type: homes::ssh::private
#
# This definition will manage the distrubution of a private key for a given
# user. It will copy the private key from an existing managed key store.
#
# === Parameters
#
# [*username*]
# String, required parameter. The name of the user for which the provided
# key belongs.
#
# [*key_name*]
# String, required parameter. The name of the private key that will be managed.
#
# [*key_store*]
# String, required parameter. The full path to the directory that stores
# the private key.
#
# === Examples
#
# Manage the private for a given user:
#
# homes::ssh::private { 'id_rsa for testuser':
#  username => 'testuser',
#  key_name => 'id_rsa',
#  key_store => '/var/lib/keystore/id_rsa'
# }
#
define homes::ssh::private(
  $username,
  $home,
  $key_store,
  $key_name = $name
) {

  if "x${home}x" == 'xx' {
    $homedir = "/home/${username}"
  } else {
    $homedir = $home
  }

  file { "${homedir}/.ssh/${key_name}":
    ensure  => present,
    source  => "${key_store}/${key_name}",
    mode    => '0600',
    require => File["${homedir}/.ssh"]
  }
}
