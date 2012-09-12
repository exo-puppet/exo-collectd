class collectd::plugin::apache( $activated=true, $apache_host="localhost", $apache_port="80" ) {
    
    if ( $activated == true ) {
        file { "${collectd::params::configuration_d_dir}/apache.conf":
            ensure => file,
            owner  => root,
            group  => root,
            content => template ("collectd/etc/collectd.d/apache.conf.erb"),
            require => File ["${collectd::params::configuration_d_dir}"],
            notify => Class["collectd::service"],
        }
    } else {
        file { "${collectd::params::configuration_d_dir}/apache.conf":
            ensure => absent,
            notify => Class["collectd::service"],
        }
    }
}