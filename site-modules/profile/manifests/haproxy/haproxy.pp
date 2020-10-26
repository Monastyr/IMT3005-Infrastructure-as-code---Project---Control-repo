class profile::haproxy {
 node 'haproxy-server' {
  include ::haproxy
  haproxy::listen { 'puppet00':
    collect_exported => false,
    ipaddress        => $::ipaddress,
    ports            => '8140',
  }
  haproxy::balancermember { 'server00':
    listening_service => 'puppet00',
    server_names      => 'server00.example.com',
    ipaddresses       => '10.0.0.10',
    ports             => '8140',
    options           => 'check',
  }
  haproxy::balancermember { 'server01':
    listening_service => 'puppet00',
    server_names      => 'server01.example.com',
    ipaddresses       => '10.0.0.11',
    ports             => '8140',
    options           => 'check',
  }
}


}