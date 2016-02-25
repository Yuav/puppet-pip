# == Class pip::params
#
# This class is meant to be called from pip.
# It sets variables according to platform.
#
class pip::params {
  $package_ensure = 'installed'
  $index_url = undef
  $extra_index_url = undef
}
