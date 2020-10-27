node default {
  notify { "Oops Default! I'm ${facts['hostname']}": }
}

node 'manager.node.consul' {
  include ::role::manager_server
}

node 'dir.node.consul' {
  include ::role::directory_server
}

node 'mon.node.consul' {
  include ::role::monitoring_server
}

node 'db.node.consul' {
  include ::role::database
}

node /(ws)\d?.node.consul/ {
  include ::role::wordpress_server
}
