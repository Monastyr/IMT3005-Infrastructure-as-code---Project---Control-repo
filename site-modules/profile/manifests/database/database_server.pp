class profile::database::database_server{


class { '::mysql::server':
  root_password           => 'password',
  restart                 => true,
}

mysql::db { 'wordpress':
  user     => 'wordpress',
  password => 'wordpress',
  host     => 'db.node.consul',
  grant    => ['SELECT', 'UPDATE'],
}

}