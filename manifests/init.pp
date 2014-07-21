# == Define Resource Type: homes
#
# This will create a local system user and manage their home directory.
# Optionally it will also manage distrubution of the public ssh key if
# it is provided.
#
# === Requirements/Dependencies
#
# Currently reequires the puppetlabs/stdlib module on the Puppet Forge in
# order to validate much of the the provided configuration.
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
# [*ssh_key*]
# String, default empty. If given, this will be used to populate the authorized_keys
# file for the given user.
#
# [*ssh_key_type*]
# String, default ssh-rsa. If given, this defined the encryption type used for the key
#
# [*ssh_config_entries*]
# Hash. If given, this will configure the entries in the ~/.ssh/config file
#
# === Examples
#
# Create a user with the provided public ssh key:
#
# homes { 'testuser'
#  ssh_key => 'AAAAB3NzaC1yc2EAAAADAQABAAAAgQC4U/G9Idqy1VvYEDCKg3noVChCbIrJAi0D/qMFoG=='
# }
#
define homes (
  $user,
  $ssh_key='',
  $ssh_key_type = 'ssh-rsa',
  $ssh_config_entries = {},
  $ensure='present'
) {

    validate_re($::osfamily, 'RedHat|Linux|Debian\b', "${::operatingsystem} not supported")
    validate_hash($user)

    $username = keys($user)

    homes::home { "${username} home is ${ensure}":
      ensure => $ensure,
      user   => $user
    }

    if $ssh_key != '' {
      validate_re($ssh_key, '[A-Za-z0-9]', "ssh_key can only contain upper or lowercase strings or numbers. ${ssh_key} is not valid")
      validate_re($ssh_key_type, 'ssh-rsa|ssh-dsa|ssh-ed25519|ecdsa-sha2-nistp256|cdsa-sha2-nistp384|ecdsa-sha2-nistp521|ssh-ed25519', 'Keytype not supported')

      homes::ssh::public { "auth_keys for ${username}":
        ensure       => $ensure,
        username     => $username,
        ssh_key      => $ssh_key,
        ssh_key_type => $ssh_key_type
      }
    }

    if !empty($ssh_config_entries) {
      homes::ssh::config { "ssh_config file for ${username}":
        username           => $username,
        ssh_config_entries => $ssh_config_entries
      }
    }
}
