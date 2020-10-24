class profile::docker::docker_worker {
	class { 'docker':}

	$token = lookup('docker_swarm::token')
	$manager_ip = lookup(manager_ip)
	
	docker::swarm {'cluster_worker':
	  join           => true,
	  advertise_addr => $facts['networking']['ip'],
	  listen_addr    => $facts['networking']['ip'],
	  manager_ip     =>$manager_ip,
	  token          => $token,
	}
	
		
}


