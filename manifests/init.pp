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
  $package_name = $::pip::params::package_name,
  $service_name = $::pip::params::service_name,
) inherits ::pip::params {

  # validate parameters here

  class { '::pip::install': } ->
  class { '::pip::config': } ->
  Class['::pip']
}
