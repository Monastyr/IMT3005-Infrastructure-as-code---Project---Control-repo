class profile::wordpress { 
	
$mysql_password        = 'password'
$wordpress_password    = 'password'

  # PHP-enabled web server
  class { 'apache':
    default_vhost => false,
    mpm_module    => 'prefork',
  }
  class { 'apache::mod::php':
      php_version => '7.2',
  }

  # Virtual Host for Wordpress
  apache::vhost { $::fqdn:
    port           => '80',
    docroot        => '/opt/wordpress',
    manage_docroot => false,
  }

  # MySQL server
  class { 'mysql::server':
    root_password => $mysql_password,
  }
  class { 'mysql::bindings':  # if added late, need to restart apache service
    php_enable => true,
    php_package_name => 'php-mysql',
  }

  # Wordpress
  user { 'wordpress':
    ensure => 'present'
  }
  class { 'wordpress':
    version     => '4.9.7',   # if changed, delete index.php, rerun puppet
                              # due to creates => "${install_dir}/index.php"
                              # in manifests/instance/app.pp
    wp_owner    => 'wordpress',
    wp_group    => 'wordpress',
    db_user     => 'wordpress',
    db_password => $wordpress_password,
    require     => [ Class['apache'], Class['mysql::server'], User['wordpress'] ],
  }

}

	

