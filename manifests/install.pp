# Class: collectd::install
#
# This class manage the installation of the collectd package
class collectd::install {
  case $::operatingsystem {
    /(Ubuntu)/ : {
      case $::lsbdistrelease {
        # for 10.10 and 11.04 I don't found PPA repo for v 5.x of Collectd
        /(10.04|11.10|12.04)/ : {
          repo::define { 'collectd-ppa-repo':
            file_name  => 'collectd-ppa-repo',
            url        => 'http://ppa.launchpad.net/jeff-kerzner/collectd/ubuntu',
            sections   => [
              'main'],
            source     => true,
            key        => 'E8A3AC5F',
            key_server => 'keyserver.ubuntu.com',
            notify     => Exec['repo-update'],
          }
        }
        /(10.11|11.04|14.04)/       : {
          # no special repo for Collectd version 4
        }
        default               : {
          fail("The ${module_name} puppet module is not (yet) supported on ${::operatingsystem} ${::operatingsystemrelease}")
        }
      }
      package { 'collectd':
        ensure  => $collectd::params::ensure_mode,
        name    => $collectd::params::package_name,
        require => [
          Exec['repo-update'],],
      } -> file { $collectd::params::configuration_d_dir:
        ensure => directory,
        owner  => root,
        group  => root,
        mode   => 644,
      } -> file { $collectd::params::plugin_dir:
        ensure => directory,
        owner  => root,
        group  => root,
        mode   => 644,
      }
    }
    default    : {
      fail("The ${module_name} module is not supported on ${::operatingsystem}")
    }
  }
}
