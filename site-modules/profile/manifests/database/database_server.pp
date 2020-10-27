class profile::database::database_server{


include '::mysql::server'

mysql::db { 'wordpress':
  user     => 'wordpress',
  password => 'wordpress',
  host     => 'db.node.consul',
  grant    => ['SELECT', 'UPDATE'],
}

}