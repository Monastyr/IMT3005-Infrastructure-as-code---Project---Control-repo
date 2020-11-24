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
  source   => 'git://github.com/vegasbrianc/prometheus.git',
}->

docker::stack { 'prom':
    ensure        => present,
    compose_files => ['/root/prom/docker-stack.yml'],
    stack_name    => 'prom',
    require       => [Class['docker'], Vcsrepo['/root/prom'], ],
  }
  
}
