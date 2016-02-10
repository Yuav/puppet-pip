# == Class pip::install
#
# This class is called from pip for install.
#
class pip::install {
  if (!defined(Package['python-pip'])) {
    package { 'python-pip': ensure => 'present', }

    if ::osfamily == 'RedHat' {
      # Include repo for RHEL distros which include the pip package
      class { '::epel': }

      Package <| title == 'python-pip' |> {
        require => Class['epel'],
      }
    }
  }

  # Upgrade pip using pip
  package { 'pip':
    ensure   => 'latest',
    provider => 'yuavpip',
    require  => Package['python-pip'],
  }

}
