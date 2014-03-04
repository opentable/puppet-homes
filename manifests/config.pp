# == Define homes::config
#
# This define is called from homes
#
define homes::config(
  $user,
  $ssh_key
) {

  $username = keys($user)

  create_resources(user, $user)

  file { "/home/${username}":
    ensure => directory,
    owner  => $username,
    mode   => '0600'
  }

  file { "/home/${username}/.ssh":
    ensure  => directory,
    owner   => $username,
    mode    => '0600',
    require => File["/home/${username}"]
  }

  ssh_authorized_key { $username:
    ensure  => present,
    key     => $ssh_key,
    target  => "/home/${username}/.ssh/authorized_keys",
    type    => 'ssh-rsa',
    user    => $username,
    require => User[$username]
  }

  file { "/home/${username}/.ssh/authorized_keys":
    ensure  => present,
    owner   => $username,
    mode    => '0644'
  }
}
