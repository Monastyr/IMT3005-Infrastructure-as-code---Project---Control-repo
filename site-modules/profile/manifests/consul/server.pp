class profile::consul::server {

  package { 'unzip':
    ensure => latest,
  }

  class { '::consul':
    version     => '1.6.2',
    config_hash => {
      'bootstrap_expect' => 3,
      'data_dir'         => '/opt/consul',
      'datacenter'       => 'NTNU',
      'log_level'        => 'INFO',
      'node_name'        => $facts['hostname'],
      'server'           => true,
      'retry_join'       => [ $::serverip ],
	  'ui'               => true,
    },
    require     => Package['unzip'],
  }
  
  exec { 'database_ip':
			command => '/bin/echo "database_ip: $(/usr/local/bin/consul members | grep db | tr [:] [" "] | cut -d " " -f8) " >> /etc/puppetlabs/code/shared-hieradata/common.yaml'
			#$database_ip = lookup(database_ip)
			}
			

}

