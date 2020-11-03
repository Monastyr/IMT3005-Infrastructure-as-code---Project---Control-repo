class role::wordpress_server{
  include ::profile::base_linux
  include ::profile::dns::client
  include ::profile::consul::client
  #include ::profile::wordpress
  include ::profile::docker::docker_worker
  include ::profile::glusterfs::glusterfs
  }
