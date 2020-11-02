class profile::database::database_server{


class { 'galera':
  cluster_name    => 'mycluster',
  galera_servers  => ['db2.node.consul'],
  galera_master   => 'd1.example.com',
  root_password   => 'pa$$w0rd',
  status_password => 'pa$$w0rd',
}
#class { '::mysql::server':
  #root_password           => 'password',
 # override_options => {'mysqld' => {'bind-address' => '0.0.0.0'}},
 # }



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