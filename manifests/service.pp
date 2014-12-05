#
class rngd::service {

  if $::rngd::service_manage {
    service { $::rngd::service_name:
      ensure     => $::rngd::service_ensure,
      enable     => $::rngd::service_enable,
      hasstatus  => true,
      hasrestart => true,
    }
  }
}
