# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include wordpress::conf
class wordpress::conf {
    # You can change the values of these variables
    # according to your preferences


    $volumepath = '/var/www/html/wp-content'
    $db_name = 'wordpress'
    $db_user = 'boss'
    $db_user_password = 'boss'
    $db_host = 'db1.node.consul'

    # Don't change the following variables

    # This will evaluate to wp@localhost
    #$db_user_host = "${db_user}@${db_host}"

    # This will evaluate to wp@localhost/wordpress.*
    #$db_user_host_db = "${db_user}@${db_host}/${db_name}.*"
}
