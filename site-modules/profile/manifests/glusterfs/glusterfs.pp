class profile::glusterfs::glusterfs{

	
	  file { ['/export', '/export/brick1', '/export/brick1/brick']:
		ensure => 'directory',
	  }
	  
	  
	  # first, install the upstream Gluster packages
	  class { ::gluster::install:
		server  => true,
		client  => true,
		repo    => false,
		version => '3.5.2',
	  }

	  # make sure the service is started
	  class { ::gluster::service:
		ensure  => running,
		require => Class[::gluster::install],
	  }

	  # now establish a peering relationship
	  gluster::peer { [ 'manager.node.consul', 'ws1.node.consul' ]:
		pool    => 'production',
		require => Class[::gluster::service],
	  }

	  gluster::volume { 'g0':
		replica => 2,
		bricks  => [ 'manager.node.consul:/export/brick1/brick',
						 'ws1.node.consul:/export/brick1/brick', ],
		options => [ 'nfs.disable: true' ],
		require => Gluster::Peer[ [ 'manager.node.consul', 'ws1.node.consul' ] ],
	  }
	

}