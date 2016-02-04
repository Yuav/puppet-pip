# == Class pip::install
#
# This class is called from pip for install.
#
class pip::install {
  # Get latest PIP version which supports custom PyPI repo
  #exec { 'install_pip':
  #  command => '/usr/bin/curl --silent --show-error --retry 5 https://bootstrap.pypa.io/get-pip.py | /usr/bin/sudo python2.7 && hash -r',
  #  unless  => 'which pip && pip --version | grep -F 7.',
  #  path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin'],
  #  require => [Package['python-dev'], Package['curl']],
  #}

  package { $::pip::package_name: ensure => present, }
}
