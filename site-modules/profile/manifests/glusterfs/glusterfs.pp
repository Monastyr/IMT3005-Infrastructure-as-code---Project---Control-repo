class profile::glusterfs::glusterfs{

	  # first, install the upstream Gluster packages
	  class { ::gluster::install:
		server  => true,
		client  => true,
		repo    => true,
		version => '3.5.2',
	  }

	  # make sure the service is started
	  class { ::gluster::service:
		ensure  => running,
		require => Class[::gluster::install],
	  }

	  # now establish a peering relationship
	  gluster::peer { [ 'srv1.local', 'srv2.local' ]:
		pool    => 'production',
		require => Class[::gluster::service],
	  }

	  gluster::volume { 'g0':
		replica => 2,
		bricks  => [ 'srv1.local:/export/brick1/brick',
					 'srv2.local:/export/brick1/brick', ],
		options => [ 'nfs.disable: true' ],
		require => Gluster::Peer[ [ 'srv1.local', 'srv2.local' ] ],
	  }
	

}