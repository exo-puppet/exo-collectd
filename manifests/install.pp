# Class: collectd::install
#
# This class manage the installation of the collectd package
class collectd::install {

    case $::operatingsystem {
        /(Ubuntu)/: {
            case $::lsbdistrelease {
                /* for 10.10 and 11.04 I don't found PPA repo */ 
                /(10.04|11.10|12.04)/: {
                    repo::define { "collectd-ppa-repo":
                        file_name   => "git-core-ppa",
                        url         => "http://ppa.launchpad.net/jeff-kerzner/collectd/ubuntu",
                        sections    => ["main"],
                        source      => true,
                        key         => "E8A3AC5F",
                        key_server  => "keyserver.ubuntu.com",
                        notify      => Exec["repo-update"],
                    } ->
                    package { "collectd" :
                        name    => $openldap::params::package_name,
                        ensure  => $openldap::params::ensure_mode,
                        require => [ Exec ["repo-update"],],
                    } ->
                    file { "${collectd::params::configuration_d_dir}":
                        ensure  => directory,
                        owner   => root,
                        group   => root,
                        mode    => 644,
                    } ->
                    file { "${collectd::params::configuration_dir}/collectd.conf":
                        ensure  => file,
                        owner   => root,
                        group   => root,
                        mode    => 644,
                        content => template ("collectd/etc/collectd/collectd.conf.erb"),
                    }
                }
                default: {
                    fail ("The ${module_name} puppet module is not (yet) supported on $::operatingsystem $::operatingsystemrelease")
                }
            }
        }
        default: {
            fail ("The ${module_name} module is not supported on $::operatingsystem")
        }
    }
}