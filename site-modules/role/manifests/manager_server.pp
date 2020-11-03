class role::manager_server {
  include ::profile::base_linux
  include ::profile::dns::client
  include ::profile::consul::server
  include ::profile::docker::docker_master
  include ::profile::glusterfs::glusterfs
}
