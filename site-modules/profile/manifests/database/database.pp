class profile::database::database{


include '::mysql::server'

	mysql::db { 'wordpress':
	  user     => 'wordpress',
	  password => 'wordpress',
	  host     => $facts['networking']['ip'],
	  grant    => ['SELECT', 'UPDATE'],
	}

}