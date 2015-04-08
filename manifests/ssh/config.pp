# Author::    Liam Bennett  (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Define Resource Type: homes::ssh::config
#
# This definition will manage the ssh config file for the given user
# === Parameters
#
# [*username*]
# String, required parameter. The name of the user for which the provided
# key belongs.
#
# [*key_name*]
# Hash. The set of enteries to populate the file with.
#
# === Examples
#
# Manage the config file for a given user:
#
#   $entries = {
#     'Host' => { 'ensure' => 'present', 'value' => 'github.com' },
#     'HostName' => { 'ensure' => 'present', 'value' => 'github.com' },
#     'User' => { 'ensure' => 'present', 'value' => 'testuser' },
#     'IdentityFile' => { 'ensure' => 'present', 'value' => '~/.ssh/id_rsa' }
#   }
#
#   homes::ssh::config { 'config for testuser':
#     username => 'testuser',
#     ssh_config_enteries => $entries
#   }
#
define homes::ssh::config(
  $username,
  $home,
  $ssh_config_entries = {},
  $ruby_augeas_version = '0.5.0'
) {

  if "x${home}x" == 'xx' {
    $homedir = "/home/${username}"
  } else {
    $homedir = $home
  }

  case $::osfamily {
    'Debian': {
      $ruby_version_array = split($::rubyversion, '[.]')
      if $ruby_version_array[0] >= 2 {
        package { ['pkg-config', 'libaugeas-dev']:
          ensure => present,
          before => Package['ruby-augeas']
        }

        package { 'ruby-augeas':
          ensure   => present,
          provider => 'gem',
          install_options => "-v ${$ruby_augeas_version}"
        }
      } else {
        ensure_resource('package', 'libaugeas-ruby', { 'ensure' => 'installed' })
      }
    }
    'RedHat': {
      ensure_resource('package', 'ruby-augeas', { 'ensure' => 'installed' })
    }
    default: {
      notify { "Can't install augeas libraries for ${::osfamily}": }
    }
  }

  ensure_resource('file', "${homedir}/.ssh/config", { 'ensure' => 'present' })

  $config_defaults = {
    'target' => "${homedir}/.ssh/config"
  }
  #create_resources('ssh_config', $ssh_config_entries, $config_defaults)
}
