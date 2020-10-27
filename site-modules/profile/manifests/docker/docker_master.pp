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
  dbcluster:
    image: toughiq/mariadb-cluster
    networks:
      - dbnet
    environment:
      - DB_SERVICE_NAME=dbcluster
      - MYSQL_ROOT_PASSWORD=password
      - MYSQL_DATABASE=mydb
      - MYSQL_USER=mydbuser
      - MYSQL_PASSWORD=mydbpass
    deploy:
      mode: replicated
      replicas: 4
	  placement:
        constraints: [node.role == worker]

  dblb:
    image: toughiq/maxscale
    networks:
      - dbnet
    ports:
      - 3306:3306
    environment:
      - DB_SERVICE_NAME=dbcluster
      - ENABLE_ROOT_USER=1
    deploy:
      mode: replicated
      replicas: 1

  wordpress:
     depends_on:
       - dblb
     image: wordpress:latest
    networks:
      - dbnet	 
     volumes:
       - /mnt/wp-content:/var/www/html/wp-content
     ports:
       - \"80:80\"
     restart: always
     environment:
       WORDPRESS_DB_HOST: dblb:3306
       WORDPRESS_DB_USER: wordpress
       WORDPRESS_DB_PASSWORD: wordpress
       WORDPRESS_DB_NAME: wordpress
     deploy:
      replicas: 3
      placement:
        constraints: [node.role == worker]

volumes:
  vol_dbclient:
    driver: local

networks:
  dbnet:
    name: dbnet
    driver: overlay"
}
	
	docker::stack { 'test':
		compose_files => ['/tmp/docker-compose.yml'],
		ensure  => present,
		stack_name => 'wp',
		require => [Class['docker'], File['/tmp/docker-compose.yml'], ], 
	}
	

}
