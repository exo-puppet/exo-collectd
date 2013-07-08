class collectd::plugin::write_graphite (
  $activated     = true,
  $graphite_host,
  $graphite_port = '2003') {
  if ($activated == true) {
    case $collectd::params::collectd_version {
      /(5)/   : {
        # Collectd version 5
        # => the write_graphite plugin is bundled with the package
        # => no need of the external carbon_writer python script
        #
        file { "${collectd::params::plugin_dir}/carbon_writer.py":
          ensure => absent,
          notify => Class['collectd::service'],
        }

        file { "${collectd::params::plugin_dir}/carbon_writer.pyc":
          ensure => absent,
          notify => Class['collectd::service'],
        }

      }
      /(4)/   : {
        # Collectd version 4
        # => the write_graphite plugin is NOT bundled with the package
        # => we need the external carbon_writer python script
        #
        file { "${collectd::params::plugin_dir}/carbon_writer.py":
          ensure  => file,
          owner   => root,
          group   => root,
          content => template("collectd${collectd::params::plugin_dir}/carbon_writer.py.erb"),
          require => File[$collectd::params::plugin_dir],
          notify  => Class['collectd::service'],
        }
      }
      default : {
        fail("Only Collectd version 4 or 5 are currently managed by the ${module_name} puppet module")
      }
    }

    file { "${collectd::params::configuration_d_dir}/write_graphite.conf":
      ensure  => file,
      owner   => root,
      group   => root,
      content => template("collectd/etc/collectd.d/write_graphite.conf-v${collectd::params::collectd_version}.erb"),
      require => File[$collectd::params::configuration_d_dir],
      notify  => Class['collectd::service'],
    }
  } else {
    file { "${collectd::params::configuration_d_dir}/write_graphite.conf":
      ensure => absent,
      notify => Class['collectd::service'],
    }

    file { "${collectd::params::plugin_dir}/carbon_writer.py":
      ensure => absent,
      notify => Class['collectd::service'],
    }

    file { "${collectd::params::plugin_dir}/carbon_writer.pyc":
      ensure => absent,
      notify => Class['collectd::service'],
    }
  }
}
