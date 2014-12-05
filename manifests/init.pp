#
class rngd (
  $package_ensure = $::rngd::params::package_ensure,
  $package_name   = $::rngd::params::package_name,
  $service_enable = $::rngd::params::service_enable,
  $service_ensure = $::rngd::params::service_ensure,
  $service_manage = $::rngd::params::service_manage,
  $service_name   = $::rngd::params::service_name
) inherits ::rngd::params {

  validate_string($package_ensure)
  validate_string($package_name)
  validate_bool($service_enable)
  validate_re($service_ensure, '^(running|stopped)$')
  validate_bool($service_manage)
  validate_string($service_name)

  include ::rngd::install
  include ::rngd::service

  anchor { 'rngd::begin': }
  anchor { 'rngd::end': }

  Anchor['rngd::begin'] -> Class['::rngd::install']
    ~> Class['::rngd::service'] -> Anchor['rngd::end']
}
