# Define: ddclient::host
#
# Adds a custom ddclient host
# Supported arguments:
# $hostname - The name you want to give the host. If not set, defaults to == $title
# $server   - The server we want to register our node with
# $login    - The user to login with
# $password - And its password
# $protocol - The protocol to use with the server
# $order    - The order in the ddclient.conf file. Default 50. Generally you don't need to change it
# $enable   - true / false. If false, the rule _IS NOT ADDED_ to the host.local file

define ddclient::host (
  $hostname  = '',
  $server    = '',
  $login     = '',
  $password  = '',
  $protocol  = '',
  $order     = '',
  $enable    = true ) {

  include ddclient
  include concat::setup

  $real_hostname = $hostname ? {
    ''      => $title,
    default => $hostname,
  }

  # If (concat) order is not defined we find out the right one
  $real_order = $order ? {
    ''      => '50',
    default => $order,
  }

  $ensure = bool2ensure($enable)

  concat::fragment{ "ddclient_host_$name":
    ensure  => $ensure,
    target  => $ddclient::config_file,
    content => template('ddclient/ddclient.conf-stanza.erb'),
    order   => $real_order,
    notify  => Service['ddclient'],
  }
}
