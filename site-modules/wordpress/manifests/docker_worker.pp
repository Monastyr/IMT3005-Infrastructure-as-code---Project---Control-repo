# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include wordpress::docker_worker
  
class wordpress::docker_worker {
  class { 'docker':}

  $token = lookup('docker_swarm::token')
  docker::swarm {'cluster_worker':
    join           => true,
    advertise_addr => $facts['networking']['ip'],
    listen_addr    => $facts['networking']['ip'],
    manager_ip     =>'manager.node.consul',
    token          => $token,
  }

}