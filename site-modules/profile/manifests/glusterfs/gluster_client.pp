class profile::glusterfs::gluster_client{

	class { ::gluster::install:
		server  => true,
		client  => true,
		repo    => false,
	  }
	  
	   class { ::gluster::service:
		ensure  => running,
		require => Class[::gluster::install],
	  }

}
