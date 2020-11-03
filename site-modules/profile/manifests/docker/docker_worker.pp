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
	
	
	
	  file { ['/export/', '/export/brick1/', '/export/brick1/brick/']:
		ensure => 'directory',
	  }	
	
class { ::gluster::client:
  repo    => false,
}		
			
			
			
gluster::mount { '/mnt/':
	  volume  => 'localhost:/g0',
	  atboot  => true,
	  options => 'noatime,nodev,noexec,nosuid',
}			
}


