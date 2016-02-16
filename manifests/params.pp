# == Class pip::params
#
# This class is meant to be called from pip.
# It sets variables according to platform.
#
class pip::params {
  $package_ensure = 'installed'
  $pypi_repo = undef
}
