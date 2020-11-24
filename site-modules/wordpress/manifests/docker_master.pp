class wordpress::docker_master {
  class { 'docker':}

      docker::swarm {'cluster_manager':
        init           => true,
        advertise_addr =>  $facts['networking']['ip'],
        listen_addr    =>  $facts['networking']['ip'] ,
        before         => Exec[token]
        }

       #will fix it one day
      exec { 'token':
        command => '/bin/echo -n  "docker_swarm::token: " >> /etc/puppetlabs/code/shared-hieradata/common.yaml',
        before  => Exec[token2]
        }
      exec { 'token2':
        command => '/bin/echo  $( /usr/bin/docker swarm join-token worker | tail -2 | cut -d " " -f9) >> /etc/puppetlabs/code/shared-hieradata/common.yaml',
        }

      exec { 'token3':
        command => '/bin/echo -n  "docker_swarm_manager::token: " >> /etc/puppetlabs/code/shared-hieradata/common.yaml',
        before  => Exec[token2]
        }
      exec { 'token4':
        command => '/bin/echo  $( /usr/bin/docker swarm join-token manager | tail -2 | cut -d " " -f9) >> /etc/puppetlabs/code/shared-hieradata/common.yaml',
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