# == Class pip::params
#
# This class is meant to be called from pip.
# It sets variables according to platform.
#
class pip::params {
  case $::osfamily {
    'Debian': {
      $package_name = 'pip'
      $service_name = 'pip'
    }
    'RedHat', 'Amazon': {
      $package_name = 'pip'
      $service_name = 'pip'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
