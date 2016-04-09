#
class rngd::params {

  $package_ensure = 'installed'
  $service_enable = true
  $service_ensure = 'running'

  case $::osfamily {
    'RedHat': {
      case $::operatingsystemmajrelease {
        '5': {
          # The package is different and lacks an init script on 5.x
          $package_name   = 'rng-utils'
          $service_manage = false
        }
        default: {
          $package_name   = 'rng-tools'
          $service_manage = true
        }
      }
      $hasstatus    = true
      $service_name = 'rngd'
    }
    'Debian': {
      $hasstatus      = false
      $package_name   = 'rng-tools'
      $service_manage = true
      $service_name   = 'rng-tools'
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.") # lint:ignore:80chars
    }
  }
}
