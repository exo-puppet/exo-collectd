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
    } ->
    file { "${collectd::params::configuration_dir}/collectd.conf":
        ensure  => file,
        owner   => root,
        group   => root,
        mode    => 644,
        content => template ("collectd/etc/collectd/collectd.conf-v${collectd::params::collectd_version}.erb"),
        require => Package ["collectd"],
        notify  => Class["collectd::service"],
    }
}
