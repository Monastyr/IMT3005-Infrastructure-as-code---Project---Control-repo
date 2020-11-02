class profile::database::database_server{


class { '::mysql::server':
  root_password           => 'password',
  override_options => {'mysqld' => {'bind-address' => '0.0.0.0'}},
  }



mysql::db {'wordpress':
	user 			=> 'boss',
	password 	=> 'boss',
	dbname 	=> 'wordpress',
	host 			=> '%',
	grant  		=> ['ALL PRIVILEGES'],
}


#mysql_user { 'boss2@%':
  #ensure                   => 'present',
  #password_hash => mysql_password('boss'),
#} ->	


#mysql_grant { 'boss2@%/*.*':
# ensure     => 'present',
 #options    => ['GRANT'],
 #privileges => ['ALL PRIVILEGES'],
 #table      => '*.*',
 #user       => 'boss2@%',
#}


}