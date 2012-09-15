class collectd::plugin::mysql( $activated=true, $mysql_username="collectd", $mysql_password, $mysql_socket="/var/run/mysqld/mysqld.sock" ) {
    
    if ( $activated == true ) {
        file { "${collectd::params::configuration_d_dir}/mysql.conf":
            ensure => file,
            owner  => root,
            group  => root,
            content => template ("collectd/etc/collectd.d/mysql.conf.erb"),
            require => File ["${collectd::params::configuration_d_dir}"],
            notify => Class["collectd::service"],
        }
    } else {
        file { "${collectd::params::configuration_d_dir}/mysql.conf":
            ensure => absent,
            notify => Class["collectd::service"],
        }
    }
}