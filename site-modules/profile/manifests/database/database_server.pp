class profile::database::database_server{


class { 'mysql::server':
    root_password =>'password',
  }
  class { 'mysql::bindings':  # if added late, need to restart apache service
    php_enable => true,
    php_package_name => 'php-mysql',
  }


}