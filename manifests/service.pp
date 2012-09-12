# Class: collectd::service
#
# This class manage the collectd service
class collectd::service {
	service { "collectd":
		ensure     => running,
		name       => $collectd::params::service_name,
		hasstatus  => true,
		hasrestart => true,
		require => Class["collectd::config"],
	}
}
