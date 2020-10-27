class profile::wordpress { 
	
	
	
	selboolean { 'httpd_can_network_connect_db':
    persistent => true,
    value => on,
  }
  
	class { 'apache': }
	
	apache::vhost { 'wordpress.com':
		port             => '80',
	    docroot          => '/var/www/wordpress',
		#fallbackresource => '/index.php',
	}
	
	
	class { 'wordpress':
		db_user	=> 'wordpress',
		db_password => 'wordpress',
		db_host => 'db.node.consul:3306',
		install_dir => '/var/www/wordpress',
	}

}

	

