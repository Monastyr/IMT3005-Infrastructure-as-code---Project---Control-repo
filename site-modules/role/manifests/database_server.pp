class role::database_server{
  include ::profile::base_linux
  include ::profile::dns::client
  include ::profile::consul::client
  include ::profile::database::database_server
  }
