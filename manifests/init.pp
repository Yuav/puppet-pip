# Class: pip
#===========================
#
# Installs and configures Python Pip
#
# Parameters
#----------
#
# * `package_ensure`
#   Specify package ensure parameter. Defaults to 'installed'
# * `pypi_repo`
#   Configure global PyPI repository. Requires PIP version 6.0 or above.
#   Use 'latest' keyword with package_ensure parameter to get latest Pip
#   installed
#
class pip (
  $package_ensure = $::pip::params::package_ensure,
  $pypi_repo = $::pip::params::pypi_repo,
) inherits ::pip::params {

  validate_string($package_ensure)
  validate_string($pypi_repo)

  class { '::pip::install': } ->
  class { '::pip::config': } ->
  Class['::pip']
}
