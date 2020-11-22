# @summary A short summary of the purpose of this class
#
# A description of what this class does
# Used for variables in database_server

# @example
#   include wordpress::conf

class wordpress::conf {
    # You can change the values of these variables
    # according to your preferences


    $volumepath = '/var/www/html'
    $db_user = 'boss'
    $db_password = 'boss'
    $db_host = 'db1.node.consul'
    $db_name = 'wordpress'
    $replicas = '3'
    $root_password = 'password'
    $stack_name = 'wp'
    $web1 = 'web1.node.consul'

    # Don't change the following variables

    # This will evaluate to wp@localhost
    #$db_user_host = "${db_user}@${db_host}"

    # This will evaluate to wp@localhost/wordpress.*
    #$db_user_host_db = "${db_user}@${db_host}/${db_name}.*"
}
