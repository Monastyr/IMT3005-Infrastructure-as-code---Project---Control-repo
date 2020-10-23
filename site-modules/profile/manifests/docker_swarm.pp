class profile::docker_swarm {
	class { 'docker':}



	if $hostname == 'manager' {
			docker::swarm {'cluster_manager':
			  init           => true,
			  advertise_addr =>  $facts['networking']['ip'],
			  listen_addr    =>  $facts['networking']['ip'] ,
			  before => Exec[token]
			  }
			 
			 exec { 'manager_ip':
				command => '/bin/echo "manager_ip: $(/opt/puppetlabs/bin/facter ipaddress)" >> /etc/puppetlabs/code/shared-hieradata/common.yaml',
				}
			 
			 #will fix it one day
			exec { 'token':
				command => '/bin/echo -n  "docker_swarm::token: " >> /etc/puppetlabs/code/shared-hieradata/common.yaml',
				before => Exec[token2]
				}
			exec { 'token2':
				command => '/bin/echo  $( /usr/bin/docker swarm join-token worker | tail -2 | cut -d " " -f9) >> /etc/puppetlabs/code/shared-hieradata/common.yaml',
				}
	} else {
	
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
		
}


