# == Class: rngd
#
# This class sets up the rngd daemon used to feed random data from hardware
# devices to the kernel random device.
#
# === Parameters
#
# [*hasstatus*]
#   Does the rngd service support status.
#   Default: true
#
# [*hwrng_device*]
#   Kernel device to read random number input from.
#   Default: undef
#
# [*package_ensure*]
#   Intended state of the package providing the rngd daemon.
#   Default: installed
#
# [*package_name*]
#   The package name that provides the rngd daemon.
#   Default: rng-tools
#
# [*service_enable*]
#   Whether to enable the rngd service.
#   Default: true
#
# [*service_ensure*]
#   Intended state of the rngd service.
#   Default: running
#
# [*service_manage*]
#   Whether to manage the rngd service or not.
#   Default: true
#
# [*service_name*]
#   The name of the rngd service.
#   Default: rngd
#
# === Variables
#
# None.
#
# === Examples
#
#  class { 'rngd': }
#
# === Authors
#
# Matt Dainty <matt@bodgit-n-scarper.com>
#
# === Copyright
#
# Copyright 2016 Matt Dainty, unless otherwise noted.
#
class rngd (
  $hasstatus      = $::rngd::params::hasstatus,
  $hwrng_device   = undef,
  $package_ensure = $::rngd::params::package_ensure,
  $package_name   = $::rngd::params::package_name,
  $service_enable = $::rngd::params::service_enable,
  $service_ensure = $::rngd::params::service_ensure,
  $service_manage = $::rngd::params::service_manage,
  $service_name   = $::rngd::params::service_name
) inherits ::rngd::params {

  validate_string($package_ensure)
  validate_string($package_name)
  if $hwrng_device {
    validate_absolute_path($hwrng_device)
  }
  validate_bool($service_enable)
  validate_re($service_ensure, '^(running|stopped)$')
  validate_bool($service_manage)
  validate_string($service_name)

  include ::rngd::install
  include ::rngd::config
  include ::rngd::service

  anchor { 'rngd::begin': }
  anchor { 'rngd::end': }

  Anchor['rngd::begin'] -> Class['::rngd::install']
    ~> Class['::rngd::config'] ~> Class['::rngd::service']
    -> Anchor['rngd::end']
}
