class collectd::plugin::write_graphite( $activated=true, $graphite_host, $graphite_port="2003" ) {
    
    if ( $activated == true ) {
        file { "${collectd::params::configuration_d_dir}/write_graphite.conf":
            ensure => file,
            owner  => root,
            group  => root,
            content => template ("collected/plugins/write_graphite.conf.erb"),
            require => File ["${collectd::params::configuration_d_dir}"],
            notify => Class["collectd::service"],
        }
    } else {
        file { "${collectd::params::configuration_d_dir}/write_graphite.conf":
            ensure => absent,
            notify => Class["collectd::service"],
        }
    }
}