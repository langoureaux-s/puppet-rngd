#
class rngd::params {

  case $::osfamily {
    'RedHat': {
      case $::operatingsystemmajrelease {
        5: {
          # The package is different and lacks an init script on 5.x
          $package_name   = 'rng-utils'
          $service_manage = false
        }
        6, 7: {
          $package_name   = 'rng-tools'
          $service_manage = true
        }
        default: {
          fail("The ${module_name} module is not support on an ${::osfamily} ${::operatingsystemmajrelease} based system.") # lint:ignore:80chars
        }
      }
      $package_ensure = 'installed'
      $service_enable = true
      $service_ensure = 'running'
      $service_name   = 'rngd'
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.") # lint:ignore:80chars
    }
  }
}
