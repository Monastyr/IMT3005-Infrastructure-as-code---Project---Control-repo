class profile::glusterfs::gluster_client{

	class { ::gluster::client:
	  repo    => false,
	}

}
