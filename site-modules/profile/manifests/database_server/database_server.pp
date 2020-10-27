class profile::database_server::database_server{


include '::mysql::server'

mysql::db { 'wordpress':
  user     => 'myuser',
  password => 'mypass',
  host     => '${fqdn}',
  grant    => ['SELECT', 'UPDATE'],
}

}