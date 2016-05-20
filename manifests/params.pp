# Class: collectd::params
#
# This class manage the collectd parameters for different OS
class collectd::params {
  $ensure_mode = $collectd::lastversion ? {
    true    => latest,
    default => present
  }
  info("collectd ensure mode = ${ensure_mode}")

  case $::operatingsystem {
    /(Ubuntu)/ : {
      $package_name        = 'collectd'
      $service_name        = 'collectd'
      $configuration_dir   = '/etc/collectd'
      $configuration_d_dir = '/etc/collectd.d'
      $plugin_dir          = '/usr/lib/collectd-plugins'

      case $::lsbdistrelease {
        # for 10.10 and 11.04 I don't found PPA repo for v 5.x of Collectd
        /(10.04|11.10|12.04)/ : {
          # Collectd version 5
          $collectd_version = 5
        }
        /(10.11|11.04)/       : {
          # Collectd version 4
          $collectd_version = 4
        }
        default               : {
          fail("The ${module_name} puppet module is not (yet) supported on ${::operatingsystem} ${::operatingsystemrelease}")
        }
      }
    }
    default    : {
      fail("The ${module_name} module is not supported on ${::operatingsystem}")
    }
  }
}
