profile::glusterfs::gluster_client.pp{

	class { ::gluster::client:
	  repo    => flase,
	}

}
