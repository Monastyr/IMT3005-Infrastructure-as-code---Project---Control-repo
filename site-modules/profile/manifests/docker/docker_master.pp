class profile::docker::docker_master {
	class { 'docker':}
	
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
			#exec { 'database_ip':
			#command => '/bin/echo "database_ip: $(/usr/local/bin/consul members | grep db | tr [:] [" "] | cut -d " " -f8) " >> /etc/puppetlabs/code/shared-hieradata/common.yaml'
			#}
			
	class {'docker::compose':
	  ensure => present,
	}

	file { '/tmp/docker-compose.yml':
		ensure  => present,
		content => "
version: '3.5'
services:
  wordpress:
     image: wordpress:latest	 
     volumes:
       - wp-content:/var/www/html/wp-content
     ports:
       - \"80:80\"
     restart: always
     environment:
       WORDPRESS_DB_HOST: db.node.consul:3306
       WORDPRESS_DB_USER: boss2
       WORDPRESS_DB_PASSWORD: boss2
       WORDPRESS_DB_NAME: wordpress
     deploy:
      replicas: 3
      placement:
        constraints: [node.role == worker]
volumes:
      wp-content: {}"
}
	
	docker::stack { 'test':
		compose_files => ['/tmp/docker-compose.yml'],
		ensure  => present,
		stack_name => 'wp',
		require => [Class['docker'], File['/tmp/docker-compose.yml'], ], 
	}
	

}
