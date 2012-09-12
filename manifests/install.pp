# Class: collectd::install
#
# This class manage the installation of the collectd package
class collectd::install {

    case $::operatingsystem {
        /(Ubuntu)/: {
            case $::lsbdistrelease {
                /(10.04|12.04|11.10)/: {
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