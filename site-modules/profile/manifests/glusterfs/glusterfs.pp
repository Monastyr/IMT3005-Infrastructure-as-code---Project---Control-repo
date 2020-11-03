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
	  gluster::peer { [ 'ws1.node.consul', 'ws2.node.consul', 'ws3.node.consul' ]:
		pool    => 'production',
		require => Class[::gluster::service],
	  }

	  gluster::volume { 'g0':
		replica => 4,
		bricks  => [ 'manager.node.consul:/export/brick1/brick',
						 'ws1.node.consul:/export/brick1/brick',
						 'ws2.node.consul:/export/brick1/brick',
						 'ws3.node.consul:/export/brick1/brick',],
		options => [ 'nfs.disable: true' ],
		force => true,
		require => Gluster::Peer[ [ 'ws1.node.consul', 'ws2.node.consul', 'ws3.node.consul' ] ],
	  }
	
	gluster::mount { '/mnt/':
	  volume  => 'localhost:/g0',
	  atboot  => true,
	  options => 'noatime,nodev,noexec,nosuid',
}

}