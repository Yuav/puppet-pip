# == Class pip::config
#
# This class is called from pip for service config.
#
class pip::config {
  # Configure custom PyPI repo
  file { '/etc/pip.conf':
    ensure  => 'present',
    content => template('pip/pip.conf.erb'),
  }

}
