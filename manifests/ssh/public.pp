#
define homes::ssh::public(
  $username,
  $ssh_key
) {
	
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