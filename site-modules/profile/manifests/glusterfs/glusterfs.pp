class profile::glusterfs::glusterfs{

	
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

	  # now establish a peering relationship
	#  gluster::peer { [ 'manager.node.consul', 'ws1.node.consul', 'ws2.node.consul', 'ws3.node.consul' ]:
	#	pool    => 'production',
	#	require => Class[::gluster::service],
	#  }
	
		exec { 'peer1':
				command => '/usr/sbin/gluster peer probe ws1.node.consul',
				}
		exec { 'peer2':
				command => '/usr/sbin/gluster peer probe ws2.node.consul',
				}
		exec { 'peer3':
				command => '/usr/sbin/gluster peer probe ws3.node.consul',
				}
	  gluster::volume { 'g0':
		replica => 4,
		bricks  => [ 'manager.node.consul:/export/brick1/brick',
						 'ws1.node.consul:/export/brick1/brick',
						 'ws2.node.consul:/export/brick1/brick',
						 'ws3.node.consul:/export/brick1/brick',],
		options => [ 'nfs.disable: true' ],
		force => true,
		require => Exec['peer1','peer2' ,'peer3' ],
	  }
	  
		exec { 'volStart':
				command => '/usr/sbin/gluster volume start g0',
				}
				
	gluster::mount { '/mnt/':
	  volume  => 'localhost:/g0',
	  atboot  => true,
	  options => 'noatime,nodev,noexec,nosuid',
	  require => Exec['volStart']
}

}