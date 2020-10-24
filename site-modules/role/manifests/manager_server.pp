class role::manager_server {
  include ::profile::base_linux
  include ::profile::dns::client
  include ::profile::consul::server
  #include ::profile::wordpress
  include ::profile::docker_swarm
  include ::profile::prometheus::grafana
}
