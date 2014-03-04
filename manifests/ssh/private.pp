#
define homes::ssh::private(
$name,
$username,
$keystore,
) {

	file { "/home/${username}/.ssh/${name}":
	  ensure => present,
	  source => "${keystore}/${name}",
	  mode => '0600'
	}
}