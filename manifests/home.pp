# == Define homes::home
#
# This define is called from homes
#
define homes::home(
  $user
) {

  $username = keys($user)

  create_resources(user, $user)

  file { "/home/${username}":
    ensure => directory,
    owner  => $username,
    mode   => '0600'
  }
}
