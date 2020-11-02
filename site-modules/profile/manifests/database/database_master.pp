class profile::database::database_master{

  class {'::mysql::server':
    root_password           => 'password',
    create_root_my_cnf      => true,
    remove_default_accounts => true,
    manage_config_file      => true,
    override_options        => {
      'mysqld' => {
        'datadir'                 => '/var/lib/mysql',
        'bind_address'            => '0.0.0.0',
        'server-id'               => '1',
        'read_only'               => 'OFF',
        'gtid-mode'               => 'ON',
        'enforce_gtid_consistency'=> 'ON',
        'log-slave-updates'       => 'ON',
        'sync_binlog'             => 1,
        'log-bin'                 => '/var/log/mysql-bin',
        'read_only'               => 'OFF',
        'binlog-format'           => 'ROW',
        'log-error'               => '/var/log/mysql/error.log',
        'report_host'             => $facts['fqdn'],
        'innodb_buffer_pool_size' => '512M'
      },
      'mysqld_safe' => {
        'log-error'               => '/var/log/mysql/error.log'
      }
    }

 # create slave user
  mysql_user { "slave@%":
      ensure        => 'present',
      password_hash => mysql_password("password")
  }

 # grant privileges for slave user
  mysql_grant { "slave@%":
      ensure        => 'present',
      privileges    => ['REPLICATION SLAVE'],
      table         => '*.*',
      user          => "slave@%"
  }


}