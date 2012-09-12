# Class: collectd::config
#
# This class manage the collectd configuration
class collectd::config {
    file { $collectd::params::configuration_dir:
        ensure  => directory,
        owner   => root,
        group   => root,
        mode    => 0755,
        require => Class["collectd::install"],
        notify => Class["collectd::service"],
    }
}
