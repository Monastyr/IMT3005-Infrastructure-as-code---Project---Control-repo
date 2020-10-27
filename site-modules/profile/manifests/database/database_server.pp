class profile::database::database_server{


class { '::mysql::server':
  root_password           => 'password',
  }


}