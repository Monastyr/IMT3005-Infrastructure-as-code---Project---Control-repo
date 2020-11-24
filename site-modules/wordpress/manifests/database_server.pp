# @summary A short summary of the purpose of this class
#
# A description of what this class does:
# To install a server with the default options
# To create a database with a user and some assigned privileges

class wordpress::database_server {
class { 'wordpress::conf': }

class { '::mysql::server':
  root_password    => $wordpress::conf::root_password,
  override_options => {'mysqld' => {'bind-address' => '0.0.0.0'}},
  }

mysql::db {'wordpress':
	user        => $wordpress::conf::db_user,
	password 	=> $wordpress::conf::db_password,
	dbname      => $wordpress::conf::db_name,
	host 	    => '%',
  grant  	    => ['ALL PRIVILEGES'],
	}

class { 'mysql::server::backup':
  backupuser     => 'myuser',
  backuppassword => 'mypassword',
  backupdir      => '/tmp/backups',
  provider          => 'xtrabackup',
  backuprotate      => 15,
  execpath          => '/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin',
  time              => ['14', '57'],
}
}
