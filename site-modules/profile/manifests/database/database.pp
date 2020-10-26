class profile::database::database_server{


include '::mysql::server'

mysql::db { 'word':
  user     => 'myuser',
  password => 'mypass',
  host     => '${fqdn}',
  grant    => ['SELECT', 'UPDATE'],
}

}