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
version: '3.3'

services:
   #db:
    # image: mysql:5.7
     #volumes:
     #  - db_data:/var/lib/mysql
   #  restart: always
     #environment:
    #   MYSQL_ROOT_PASSWORD: wordpress
   #    MYSQL_DATABASE: wordpress
    #   MYSQL_USER: wordpress
    #   MYSQL_PASSWORD: wordpress
   #  deploy:
   #    replicas: 3
   #    placement:
   #      constraints: [node.role == worker]
#
   wordpress:
     depends_on:
       - db
     image: wordpress:latest
     volumes:
       - wp_data:/var/www/html/wp-content
     ports:
       - \"80:80\"
     restart: always
     environment:
       WORDPRESS_DB_HOST: localhost:3306
       WORDPRESS_DB_USER: wordpress
       WORDPRESS_DB_PASSWORD: wordpress
       WORDPRESS_DB_NAME: wordpress
     deploy:
      replicas: 3
      placement:
        constraints: [node.role == worker]
volumes:
  #  db_data: {}
    wp_data: {}"
}
	
	docker::stack { 'test':
		compose_files => ['/tmp/docker-compose.yml'],
		ensure  => present,
		stack_name => 'wp',
		require => [Class['docker'], File['/tmp/docker-compose.yml'], ], 
	}
}
