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

  $package = $::operatingsystem ? {
    default => 'ddclient',
  }

  $service = $::operatingsystem ? {
    default => 'ddclient',
  }

  $service_status = $::operatingsystem ? {
    default => true,
  }

  $process = $::operatingsystem ? {
    default => 'ddclient',
  }

  $process_args = $::operatingsystem ? {
    default => '',
  }

  $process_user = $::operatingsystem ? {
    default => 'ddclient',
  }

  $config_dir = $::operatingsystem ? {
    default => '/etc',
  }

  $config_file = $::operatingsystem ? {
    default => "${config_dir}/ddclient.conf",
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

  $config_file_mode = $::operatingsystem ? {
    default => '0644',
  }

  $config_file_owner = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_group = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_init = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/etc/default/ddclient',
    default                   => '/etc/sysconfig/ddclient',
  }

  $pid_file = $::operatingsystem ? {
    default => '/var/run/ddclient.pid',
  }

  $data_dir = $::operatingsystem ? {
    default => '/etc/ddclient',
  }

  $log_dir = $::operatingsystem ? {
    default => '/var/log/ddclient',
  }

  $log_file = $::operatingsystem ? {
    default => '/var/log/ddclient/ddclient.log',
  }

  $daemon_interval = '3600'
  $enable_syslog = true
  $mailto = ''
  $enable_ssl = true
  $getip_from = ''
  $getip_options = ''

  # General Settings
  $my_class = ''
  $options = ''
  $service_autorestart = true
  $version = 'present'
  $absent = false
  $disable = false
  $disableboot = false

  ### General module variables that can have a site or per module default
  $monitor = false
  $monitor_tool = ''
  $monitor_target = $::ipaddress
  $puppi = false
  $puppi_helper = 'standard'
  $debug = false
  $audit_only = false
  $noops = undef
}
