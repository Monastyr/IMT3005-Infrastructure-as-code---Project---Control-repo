class wordpress::monitor {
class { 'docker':}

  $token = lookup('docker_swarm_manager::token')
  docker::swarm {'cluster_worker':
    join           => true,
    advertise_addr => $facts['networking']['ip'],
    listen_addr    => $facts['networking']['ip'],
    manager_ip     =>'manager.node.consul',
    token          => $token,
  }


vcsrepo { '/root/prom':
  ensure   => present,
  provider => git,
  source   => 'https://github.com/vegasbrianc/prometheus.git',
}->

docker::stack { 'prom':
    ensure        => present,
    stack_name    => 'prom',
    require       => [Class['docker'], Vcsrepo['/root/prom'], ],
  }
  
}
