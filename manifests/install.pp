# Class: collectd::install
#
# This class manage the installation of the collectd package
class collectd::install {
  case $::operatingsystem {
    /(Ubuntu)/ : {
      case $::lsbdistrelease {
        # for 10.10 and 11.04 I don't found PPA repo for v 5.x of Collectd
        /(10.04|11.10|12.04)/ : {
          apt::key {'ppa:jeff-kerzner/collectd-key':
            id => '2B45553ABF5D9B299C5590591926CD31E8A3AC5F',
            server  => 'keyserver.ubuntu.com',
          } ->
          apt::ppa { 'ppa:jeff-kerzner/collectd': package_manage => true }
        }
        /(10.11|11.04|14.04)/       : {
          # no special repo for Collectd version 4
        }
        default               : {
          fail("The ${module_name} puppet module is not (yet) supported on ${::operatingsystem} ${::operatingsystemrelease}")
        }
      }
      ensure_packages ('collectd', {
        'ensure'  => $collectd::params::ensure_mode,
        'name'    => $collectd::params::package_name,
        'require' => $::lsbdistrelease ? {
          /(10.04|11.10|12.04)/ => [Apt::Ppa['ppa:jeff-kerzner/collectd'],Class['apt::update']],
          default               => Class['apt::update'],
        }
      })

      file { $collectd::params::configuration_d_dir:
        ensure => directory,
        owner  => root,
        group  => root,
        mode   => 644,
        require => Package['collectd']
      } -> file { $collectd::params::plugin_dir:
        ensure => directory,
        owner  => root,
        group  => root,
        mode   => 644,
        require => Package['collectd']
      }
    }
    default    : {
      fail("The ${module_name} module is not supported on ${::operatingsystem}")
    }
  }
}
