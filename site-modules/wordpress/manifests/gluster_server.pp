class wordpress::gluster_server{
  class { 'wordpress::conf': }	
	
	  file { ['/export/', '/export/brick1/', '/export/brick1/brick/']:
		ensure => 'directory',
	  }
	  
	  
	  # first, install the upstream Gluster packages
	  class { ::gluster::install:
		server  => true,
		client  => true,
		repo    => false,
	  }

	  # make sure the service is started
	  class { ::gluster::service:
		ensure  => running,
		require => Class[::gluster::install],
	  }
	
		exec { 'peer1':
				command => "/usr/sbin/gluster peer probe '$wordpress::conf::web1' ",
				}
		exec { 'peer2':
				command => "/usr/sbin/gluster peer probe '$wordpress::conf::web2' ",
				}
		exec { 'peer3':
				command => "/usr/sbin/gluster peer probe '$wordpress::conf::web3' ",
				}
	  gluster::volume { 'g0':
		replica => 4,
		bricks  => [ 'manager.node.consul:/export/brick1/brick',
			     "'$wordpress::conf::web1':/export/brick1/brick",
			     "'$wordpress::conf::web2':/export/brick1/brick",
			     "'$wordpress::conf::web3':/export/brick1/brick",],
		options => [ 'nfs.disable: true' ],
		force => true,
		require => Exec['peer1','peer2' ,'peer3' ],
	  }
				
	gluster::mount { '/mnt/':
	  volume  => 'localhost:/g0',
	  atboot  => true,
	  options => 'noatime,nodev,noexec,nosuid',
}->

	file { '/mnt/wp/':
		ensure => 'directory',
	  }
}