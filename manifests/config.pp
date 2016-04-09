#
class rngd::config {

  $hwrng_device = $::rngd::hwrng_device

  case $::osfamily { # lint:ignore:case_without_default
    'RedHat': {
      $options = delete_undef_values([
        $hwrng_device ? {
          undef   => undef,
          default => "-r ${hwrng_device}",
        },
      ])

      file { '/etc/sysconfig/rngd':
        ensure  => file,
        owner   => 0,
        group   => 0,
        mode    => '0644',
        content => template('rngd/sysconfig.erb'),
      }

      case $::operatingsystemmajrelease { # lint:ignore:case_without_default
        '7': {
          file { '/etc/systemd/system/rngd.service.d':
            ensure => directory,
            owner  => 0,
            group  => 0,
            mode   => '0644',
          }

          ensure_resource('exec', 'systemctl daemon-reload', {
            refreshonly => true,
            path        => $::path,
          })

          file { '/etc/systemd/system/rngd.service.d/override.conf':
            ensure  => file,
            owner   => 0,
            group   => 0,
            mode    => '0644',
            content => file('rngd/override.conf'),
            notify  => Exec['systemctl daemon-reload'],
          }
        }
      }
    }
    'Debian': {
      file { '/etc/default/rng-tools':
        ensure  => file,
        owner   => 0,
        group   => 0,
        mode    => '0644',
        content => template('rngd/default.erb'),
      }
    }
  }
}
