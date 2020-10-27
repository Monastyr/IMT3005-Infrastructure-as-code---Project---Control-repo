class profile::database::database_server{


class { '::mysql::server':
  root_password           => 'password',
  override_options        => $override_options,
  }



mysql::db {'wordpress':
	user 			=> 'boss@%',
	password 	=> 'boss',
	dbname 	=> 'wordpress',
	host 			=> '%',
	grant  		=> ['SELECT', 'UPDATE'],}


mysql_user { 'boss@%':
  ensure                   => 'present',
  password_hash => mysql_password('boss'),
} ->	


mysql_grant { 'boss@%/*.*':
 ensure     => 'present',
 options    => ['GRANT'],
 privileges => ['ALL PRIVILEGES'],
 table      => '*.*',
 user       => 'boss@%',
}


}