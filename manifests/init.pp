# Class: pip
# ===========================
#
# Full description of class pip here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class pip (
  $package_ensure = $::pip::params::package_ensure,
  $pypi_repo = $::pip::params::pypi_repo,
) inherits ::pip::params {

  class { '::pip::install': } ->
  class { '::pip::config': } ->
  Class['::pip']
}
