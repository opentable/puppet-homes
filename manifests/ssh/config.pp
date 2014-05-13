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
  $ssh_config_entries = {}
) {

  case $::osfamily {
    'Debian': {
      ensure_resource('package', 'libaugeas-ruby', { 'ensure' => 'installed' })
    }
    'RedHat': {
      ensure_resource('package', 'ruby-augeas', { 'ensure' => 'installed' })
    }
    default: {
      notify { "Can't install augeas libraries for ${::osfamily}": }
    }
  }

  ensure_resource('file', "/home/${username}/.ssh/config", { 'ensure' => 'present' })

  $config_defaults = {
    'target' => "/home/${username}/.ssh/config"
  }
  create_resources('sshd_config', $ssh_config_entries, $config_defaults)
}