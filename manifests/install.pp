#
class rngd::install {

  package { $::rngd::package_name:
    ensure => $::rngd::package_ensure,
  }
}
