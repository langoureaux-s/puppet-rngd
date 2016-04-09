#
class rngd::service {

  $hasstatus = $::rngd::hasstatus

  if $::rngd::service_manage {
    service { $::rngd::service_name:
      ensure     => $::rngd::service_ensure,
      enable     => $::rngd::service_enable,
      hasstatus  => $hasstatus,
      hasrestart => true,
      pattern    => $hasstatus ? { # lint:ignore:selector_inside_resource
        false   => 'rngd',
        default => undef,
      },
    }
  }
}
