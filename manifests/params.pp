# Class: ddclient::params
#
# This class defines default parameters used by the main module class ddclient
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to ddclient class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class ddclient::params {

  ### Application related parameters
  case $::operatingsystem {
    'Ubuntu': {
      $package = 'ddclient'
      $service = 'ddclient'
      $service_status = true
      $process = 'ddclient'
      $config_dir = '/etc'
      $config_file = "${config_dir}/ddclient.conf"
      $config_file_mode = '0600'
      $config_file_owner = 'root'
      $config_file_group = 'root'
      $config_file_init = '/etc/default/ddclient'
      $pid_file = '/var/run/ddclient.pid'
      $data_dir = '/etc/ddclient'
      $log_file = '/var/log/ddclient/ddclient.log'
    }
    default: { fail("Class['ddclient::params']: Unsupported operatingsystem: ${::operatingsystem}") }
  }

  # Define how you want to manage ddclient configuration:
  # "file" - To provide hosts stanzas as a normal file
  # "concat" - To build them up using different fragments
  #          - This option, recommended, permits the use of the
  #            ddclient::host define
  $hosts_config = ''

  $hosts_template_header = 'ddclient/concat/ddclient.conf-header.erb'
  $hosts_template_footer = ''

  # If using "file" and want to use the provided template,
  # you can set a stanza here
  $source = ''
  $template = ''
  $server = ''
  $login = ''
  $password = ''
  $protocol = ''
  $hostname = ''

  $daemon_interval = '3600'
  $enable_syslog = true
  $mailto = ''
  $enable_ssl = true
  $getip_from = ''
  $getip_options = ''

  # General Settings
  $my_class = undef
  $options = undef
  $service_autorestart = true
  $version = 'present'
  $absent = false
  $disable = false
  $disableboot = false

  ### General module variables that can have a site or per module default
  $audit_only = false
  $noops = undef
  $port = ''

}
