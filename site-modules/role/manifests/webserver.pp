class role::webserver{
  include ::profile::base_linux
  include ::profile::dns::client
  include ::profile::consul::client
  include ::wordpress::gluster_client
  include ::wordpress::docker_worker
  }
