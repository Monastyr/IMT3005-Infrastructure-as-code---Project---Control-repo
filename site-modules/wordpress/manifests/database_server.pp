# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include wordpress::database_server
class wordpress::database_server {

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
