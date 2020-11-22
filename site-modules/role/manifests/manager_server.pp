class role::manager_server {
  include ::profile::base_linux
  include ::profile::dns::client
  include ::profile::consul::server
  include ::wordpress::gluster_server
  include ::wordpress::docker_master
}
