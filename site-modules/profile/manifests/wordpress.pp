class profile::wordpress { 
	
	
	class { 'docker':
    dns => '129.241.0.201',
	}

	class {'docker::compose':
	  ensure => present,
	}

	file { '/tmp/docker-compose.yml':
		ensure  => present,
		content => "
version: '3.3'

services:
   db:
     image: mysql:5.7
     volumes:
       - db_data:/var/lib/mysql
     restart: always
     environment:
       MYSQL_ROOT_PASSWORD: somewordpress
       MYSQL_DATABASE: wordpress
       MYSQL_USER: wordpress
       MYSQL_PASSWORD: wordpress

   wordpress:
     depends_on:
       - db
     image: wordpress:latest
     ports:
       - \"80:80\"
     restart: always
     environment:
       WORDPRESS_DB_HOST: db:3306
       WORDPRESS_DB_USER: wordpress
       WORDPRESS_DB_PASSWORD: wordpress
       WORDPRESS_DB_NAME: wordpress
volumes:
    db_data: {}"
	}
	
	docker_compose { 'test':
		compose_files => ['/tmp/docker-compose.yml'],
		ensure  => present,
		require => [Class['docker'], File['/tmp/docker-compose.yml'], ], 
	}
	
}
