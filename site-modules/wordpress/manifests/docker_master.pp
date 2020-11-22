# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include wordpress::docker_master
class wordpress::docker_master {
	class { 'docker':}

      docker::swarm {'cluster_manager':
        init           => true,
        advertise_addr =>  $facts['networking']['ip'],
        listen_addr    =>  $facts['networking']['ip'] ,
        before         => Exec[token]
        }
		
      exec { 'token':
        command => '/bin/echo -n  "docker_swarm::token: " >> /etc/puppetlabs/code/shared-hieradata/common.yaml',
        before  => Exec[token2]
        }
      exec { 'token2':
        command => '/bin/echo  $( /usr/bin/docker swarm join-token worker | tail -2 | cut -d " " -f9) >> /etc/puppetlabs/code/shared-hieradata/common.yaml',
        }

  class {'docker::compose':
    ensure => present,
  }

  file { '/tmp/docker-compose.yml':
    ensure  => present,
	content => template("wordpress/docker-compose.yml.erb")
  }

  docker::stack { 'test':
    ensure        => present,
    compose_files => ['/tmp/docker-compose.yml'],
    stack_name    => $wordpress::conf::stack_name,
    require       => [Class['docker'], File['/tmp/docker-compose.yml'], ],
  }

}
