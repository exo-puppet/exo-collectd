# Class: collectd::params
#
# This class manage the collectd parameters for different OS
class collectd::params {
	
	$ensure_mode = $collectd::lastversion ? {
		true => latest,
		default => present
	}
	info ("collectd ensure mode = $ensure_mode")
	

	case $::operatingsystem {
		/(Ubuntu)/: {
            $package_name       = ["collectd"]
            $service_name       = "collectd"
            $configuration_dir  = "/etc/collectd"
            $configuration_d_dir  = "/etc/collectd.d"
		}
		default: {
			fail ("The ${module_name} module is not supported on $::operatingsystem")
		}
	}
}
