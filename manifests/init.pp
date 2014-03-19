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
$ensure='present'
) {

    validate_re($::osfamily, 'RedHat|Debian\b', "${::operatingsystem} not supported")
    validate_hash($user)

    $username = keys($user)

    homes::home { "create home for ${username}":
      ensure => $ensure,
      user   => $user
    }

    if $ssh_key != '' {
      validate_re($ssh_key, '[A-Za-z0-9]', "ssh_key can only contain upper or lowercase strings or numbers. ${ssh_key} is not valid")
      validate_re($ssh_key_type, 'ssh-rsa|ssh-dsa', "Keytype not supported")

      homes::ssh::public { "auth_keys for ${username}":
        username     => $username,
        ssh_key      => $ssh_key,
        ssh_key_type => $ssh_key_type
      }
    }
}
