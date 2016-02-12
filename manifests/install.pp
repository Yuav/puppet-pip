# == Class pip::install
#
# This class is called from pip for install.
#
class pip::install {
  if (!defined(Package['python-pip'])) {
    package { 'python-pip': ensure => 'present', }

    Package <| title == 'pip' |> {
      require => Package['python-pip'],
    }

    if $::osfamily == 'RedHat' {
      class { '::epel': }

      Package <| title == 'python-pip' |> {
        require => Class['epel'],
      }
    }
  }

  # Upgrade pip using pip
  package { 'pip':
    ensure   => $::pip::package_ensure,
    provider => 'yuavpip',
  }

}
