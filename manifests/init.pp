################################################################################
#
#   This module manages the collectd service.
#
#   Tested platforms:
#    - Ubuntu 12.04
#    - Ubuntu 11.10 Oneiric
#    - Ubuntu 10.04 Lucid
#
#
# == Parameters
#   [+lastversion+]
#       (OPTIONAL) (default: false)
#
#       this variable allow to chose if the package should always be updated to the last available version (true) or not (false)
#       (default: false)
#
# == Modules Dependencies
#
# [+repo+]
#   the +repo+ puppet module is needed to :
#
#   - refresh the repository before installing package (in collectd::install)
#
# == Examples
#
#   class { "collectd":
#       lastversion => true,
#   }
#
#   class { "collectd::plugin:write_graphite":
#       activated       => true,
#       graphite_url    => "http://zabbix.server.com",
#       graphite_port   => "2003",
#   }
#
#   Then add the following line at the end of the /etc/collectd.conf file (if it is not already the case) :
#
#       Include "/etc/collectd.d/*.conf"
#
################################################################################
class collectd (
  $lastversion = false) {
  # parameters validation
  if ($lastversion != true) and ($lastversion != false) {
    fail('lastversion must be true or false')
  }

  include repo
  include collectd::params, collectd::install, collectd::config, collectd::service
}
