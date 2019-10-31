node default {
  notify { "Oops Default! I'm ${facts['hostname']}": }
}
node 'win.node.consul' {
  include ::profile::base_windows
  include ::profile::dns::client
}
node /lin\d?.node.consul/ {
#  class { 'os_hardening': }
  include ::profile::base_linux
  include ::profile::dns::client
  include ::profile::consul::client
}
node 'manager.node.consul' {
  include ::profile::base_linux
  include ::profile::dns::client
  include ::profile::consul::server
}
node 'dir.node.consul' {
  include ::role::directory_server
}
node 'mon.node.consul' {
  include ::role::monitoring_server
}
