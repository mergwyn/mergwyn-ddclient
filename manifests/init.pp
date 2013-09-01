# = Class: ddclient
#
# This is the main ddclient class
#
#
# == Parameters
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*my_class*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, ddclient class will automatically "include $my_class"
#   Can be defined also by the (top scope) variable $ddclient_myclass
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, ddclient main config file will have the param: source => $source
#   Can be defined also by the (top scope) variable $ddclient_source
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, ddclient main config file has: content => content("$template")
#   Note source and template parameters are mutually exclusive: don't use both
#   Can be defined also by the (top scope) variable $ddclient_template
#
# [*options*]
#   An hash of custom options to be used in templates for arbitrary settings.
#   Can be defined also by the (top scope) variable $ddclient_options
#
# [*service_autorestart*]
#   Automatically restarts the ddclient service when there is a change in
#   configuration files. Default: true, Set to false if you don't want to
#   automatically restart the service.
#
# [*version*]
#   The package version, used in the ensure parameter of package type.
#   Default: present. Can be 'latest' or a specific version number.
#   Note that if the argument absent (see below) is set to true, the
#   package is removed, whatever the value of version parameter.
#
# [*absent*]
#   Set to 'true' to remove package(s) installed by module
#   Can be defined also by the (top scope) variable $ddclient_absent
#
# [*disable*]
#   Set to 'true' to disable service(s) managed by module
#   Can be defined also by the (top scope) variable $ddclient_disable
#
# [*disableboot*]
#   Set to 'true' to disable service(s) at boot, without checks if it's running
#   Use this when the service is managed by a tool like a cluster software
#   Can be defined also by the (top scope) variable $ddclient_disableboot
#
# [*monitor*]
#   Set to 'true' to enable monitoring of the services provided by the module
#   Can be defined also by the (top scope) variables $ddclient_monitor
#   and $monitor
#
# [*monitor_tool*]
#   Define which monitor tools (ad defined in Example42 monitor module)
#   you want to use for ddclient checks
#   Can be defined also by the (top scope) variables $ddclient_monitor_tool
#   and $monitor_tool
#
# [*monitor_target*]
#   The Ip address or hostname to use as a target for monitoring tools.
#   Default is the fact $ipaddress
#   Can be defined also by the (top scope) variables $ddclient_monitor_target
#   and $monitor_target
#
# [*puppi*]
#   Set to 'true' to enable creation of module data files that are used by puppi
#   Can be defined also by the (top scope) variables $ddclient_puppi and $puppi
#
# [*puppi_helper*]
#   Specify the helper to use for puppi commands. The default for this module
#   is specified in params.pp and is generally a good choice.
#   You can customize the output of puppi commands for this module using another
#   puppi helper. Use the define puppi::helper to create a new custom helper
#   Can be defined also by the (top scope) variables $ddclient_puppi_helper
#   and $puppi_helper
#
# [*debug*]
#   Set to 'true' to enable modules debugging
#   Can be defined also by the (top scope) variables $ddclient_debug and $debug
#
# [*audit_only*]
#   Set to 'true' if you don't intend to override existing configuration files
#   and want to audit the difference between existing files and the ones
#   managed by Puppet.
#   Can be defined also by the (top scope) variables $ddclient_audit_only
#   and $audit_only
#
# [*noops*]
#   Set noop metaparameter to true for all the resources managed by the module.
#   Basically you can run a dryrun for this specific module if you set
#   this to true. Default: undef
#
# Default class params - As defined in ddclient::params.
# Note that these variables are mostly defined and used in the module itself,
# overriding the default values might not affected all the involved components.
# Set and override them only if you know what you're doing.
# Note also that you can't override/set them via top scope variables.
#
# [*package*]
#   The name of ddclient package
#
# [*service*]
#   The name of ddclient service
#
# [*service_status*]
#   If the ddclient service init script supports status argument
#
# [*process*]
#   The name of ddclient process
#
# [*process_args*]
#   The name of ddclient arguments. Used by puppi and monitor.
#   Used only in case the ddclient process name is generic (java, ruby...)
#
# [*process_user*]
#   The name of the user ddclient runs with. Used by puppi and monitor.
#
# [*config_dir*]
#   Main configuration directory. Used by puppi
#
# [*config_file*]
#   Main configuration file path
#
# [*hosts_config*]
# Define how you want to manage ddclient configuration:
# "file" - To provide hosts stanzas as a normal file
# "concat" - To build them up using different fragments
#          - This option, recommended, permits the use of the ddclient::host
#            define
#
# [*server*]
#   If using "file" as config method, and want to use the provided template,
#   you can set a dDNS server here
#
# [*login*]
#   And the login required here
#
# [*password*]
#   The password here
#
# [*protocol*]
#   The protocol here (dyndns, noip2, etc.)
#
# [*hostname*]
#   The hostname your host has
#
# [*config_file_mode*]
#   Main configuration file path mode
#
# [*config_file_owner*]
#   Main configuration file path owner
#
# [*config_file_group*]
#   Main configuration file path group
#
# [*config_file_init*]
#   Path of configuration file sourced by init script
#
# [*pid_file*]
#   Path of pid file. Used by monitor
#
# [*data_dir*]
#   Path of application data directory. Used by puppi
#
# [*log_dir*]
#   Base logs directory. Used by puppi
#
# [*log_file*]
#   Log file(s). Used by puppi
#
# [*daemon_interval*]
#   Interval, in seconds, at which the daemon will wake up and check if the
#   dDNS is up-to-date.
#   Default: 3600 (1 hour)
#
# [*enable_syslog*]
#   If you want to log to syslog.
#   Default to yes
#
# [*mailto*]
#   If you want to receive a notification on the activities of ddclient.
#   Default: empty
#
# [*enable_ssl*]
#   If you want the communications to be encrypted, set this to true.
#   Default: yes
#
# [*getip_from*]
#   Method to obtain your current IP.
#   There are plenty of options, so take a look at the examples ddclient
#   provides, to find a method that suits you. "web" and a ddns provider in
#   the options are a common choice.
#
# [*getip_options*]
#   Each method to get the current host IP has several options to configure it,
#   so you can an array of options here, in the format
#   ['option_name1=option_value1',..,'option_nameN=option_valueN']
#   Sadly, I couldn't find yet a better way to pass all these options.
#   Suggestions are welcome
#
# [*protocol*]
#   The protocol used by the the service.
#   This is used by monitor, firewall and puppi (optional) components
#   Can be defined also by the (top scope) variable $ddclient_protocol
#
#
# See README for usage patterns.
#
# == Author
#   Alessandro Franceschi <al@lab42.it/>
#   Javier Bertoli <javier@netmanagers.com.ar/>
#
class ddclient (
  $my_class            = params_lookup( 'my_class' ),
  $source              = params_lookup( 'source' ),
  $template            = params_lookup( 'template' ),
  $server              = params_lookup( 'server' ),
  $login               = params_lookup( 'login' ),
  $password            = params_lookup( 'password' ),
  $protocol            = params_lookup( 'protocol' ),
  $hostname            = params_lookup( 'hostname' ),
  $service_autorestart = params_lookup( 'service_autorestart' , 'global' ),
  $options             = params_lookup( 'options' ),
  $version             = params_lookup( 'version' ),
  $absent              = params_lookup( 'absent' ),
  $disable             = params_lookup( 'disable' ),
  $disableboot         = params_lookup( 'disableboot' ),
  $monitor             = params_lookup( 'monitor' , 'global' ),
  $monitor_tool        = params_lookup( 'monitor_tool' , 'global' ),
  $monitor_target      = params_lookup( 'monitor_target' , 'global' ),
  $puppi               = params_lookup( 'puppi' , 'global' ),
  $puppi_helper        = params_lookup( 'puppi_helper' , 'global' ),
  $debug               = params_lookup( 'debug' , 'global' ),
  $audit_only          = params_lookup( 'audit_only' , 'global' ),
  $noops               = params_lookup( 'noops' ),
  $package             = params_lookup( 'package' ),
  $service             = params_lookup( 'service' ),
  $service_status      = params_lookup( 'service_status' ),
  $process             = params_lookup( 'process' ),
  $process_args        = params_lookup( 'process_args' ),
  $process_user        = params_lookup( 'process_user' ),
  $config_dir          = params_lookup( 'config_dir' ),
  $config_file         = params_lookup( 'config_file' ),
  $config_file_mode    = params_lookup( 'config_file_mode' ),
  $config_file_owner   = params_lookup( 'config_file_owner' ),
  $config_file_group   = params_lookup( 'config_file_group' ),
  $config_file_init    = params_lookup( 'config_file_init' ),
  $pid_file            = params_lookup( 'pid_file' ),
  $data_dir            = params_lookup( 'data_dir' ),
  $log_dir             = params_lookup( 'log_dir' ),
  $log_file            = params_lookup( 'log_file' ),
  $hosts_config        = params_lookup( 'hosts_config' ),
  $daemon_interval     = params_lookup( 'daemon_interval' ),
  $enable_syslog       = params_lookup( 'enable_syslog' ),
  $mailto              = params_lookup( 'mailto' ),
  $enable_ssl          = params_lookup( 'enable_ssl' ),
  $getip_from          = params_lookup( 'getip_from' ),
  $getip_options       = params_lookup( 'getip_options' ),
  $port                = params_lookup( 'port' ),
  $protocol            = params_lookup( 'protocol' )
  ) inherits ddclient::params {

  $bool_service_autorestart=any2bool($service_autorestart)
  $bool_absent=any2bool($absent)
  $bool_disable=any2bool($disable)
  $bool_disableboot=any2bool($disableboot)
  $bool_monitor=any2bool($monitor)
  $bool_puppi=any2bool($puppi)
  $bool_debug=any2bool($debug)
  $bool_audit_only=any2bool($audit_only)
  $bool_enable_syslog=any2bool($enable_syslog)

  ### Definition of some variables used in the module
  $manage_package = $ddclient::bool_absent ? {
    true  => 'absent',
    false => $ddclient::version,
  }

  $manage_service_enable = $ddclient::bool_disableboot ? {
    true    => false,
    default => $ddclient::bool_disable ? {
      true    => false,
      default => $ddclient::bool_absent ? {
        true  => false,
        false => true,
      },
    },
  }

  $manage_service_ensure = $ddclient::bool_disable ? {
    true    => 'stopped',
    default =>  $ddclient::bool_absent ? {
      true    => 'stopped',
      default => 'running',
    },
  }

  $manage_service_autorestart = $ddclient::bool_service_autorestart ? {
    true    => Service[ddclient],
    false   => undef,
  }

  $manage_file = $ddclient::bool_absent ? {
    true    => 'absent',
    default => 'present',
  }

  if $ddclient::bool_absent == true
  or $ddclient::bool_disable == true
  or $ddclient::bool_disableboot == true {
    $manage_monitor = false
  } else {
    $manage_monitor = true
  }

  $manage_audit = $ddclient::bool_audit_only ? {
    true  => 'all',
    false => undef,
  }

  $manage_file_replace = $ddclient::bool_audit_only ? {
    true  => false,
    false => true,
  }

  $real_enable_syslog = $ddclient::bool_enable_syslog ? {
    true    => 'yes',
    default => '',
  }

  $real_enable_ssl = $ddclient::bool_enable_ssl ? {
    true    => 'yes',
    default => '',
  }

  $array_getip_options = is_array($getip_options) ? {
    false     => $getip_options ? {
      ''      => [],
      default => [$getip_options],
    },
    default   => $getip_options,
  }

  # How to manage ddclient configuration
  case $ddclient::hosts_config {
    'file': {
      $manage_file_source = $ddclient::source ? {
        ''        => undef,
        default   => $ddclient::source,
      }

      $manage_file_content = $ddclient::template ? {
        ''        => undef,
        default   => template($ddclient::template),
      }

      file { 'ddclient.conf':
        ensure  => $ddclient::manage_file,
        path    => $ddclient::config_file,
        mode    => $ddclient::config_file_mode,
        owner   => $ddclient::config_file_owner,
        group   => $ddclient::config_file_group,
        require => Package[$ddclient::package],
        notify  => $ddclient::manage_service_autorestart,
        source  => $ddclient::manage_file_source,
        content => $ddclient::manage_file_content,
        replace => $ddclient::manage_file_replace,
        audit   => $ddclient::manage_audit,
        noop    => $ddclient::noops,
      }
    }
    'concat': {
      ddclient::host { $ddclient::hostname:
        server   => $ddclient::server,
        login    => $ddclient::login,
        password => $ddclient::password,
        protocol => $ddclient::protocol,
      }
    }
    default: { }
  }

  ### Managed resources
  package { $ddclient::package:
    ensure  => $ddclient::manage_package,
    noop    => $ddclient::noops,
  }

  service { 'ddclient':
    ensure     => $ddclient::manage_service_ensure,
    name       => $ddclient::service,
    enable     => $ddclient::manage_service_enable,
    hasstatus  => $ddclient::service_status,
    pattern    => $ddclient::process,
    require    => Package[$ddclient::package],
    noop       => $ddclient::noops,
  }

  ### Include custom class if $my_class is set
  if $ddclient::my_class {
    include $ddclient::my_class
  }

  ### Provide puppi data, if enabled ( puppi => true )
  if $ddclient::bool_puppi == true {
    $classvars=get_class_args()
    puppi::ze { 'ddclient':
      ensure    => $ddclient::manage_file,
      variables => $classvars,
      helper    => $ddclient::puppi_helper,
      noop      => $ddclient::noops,
    }
  }


  ### Service monitoring, if enabled ( monitor => true )
  if $ddclient::bool_monitor == true {
    if $ddclient::port != '' {
      monitor::port { "ddclient_${ddclient::protocol}_${ddclient::port}":
        protocol => $ddclient::protocol,
        port     => $ddclient::port,
        target   => $ddclient::monitor_target,
        tool     => $ddclient::monitor_tool,
        enable   => $ddclient::manage_monitor,
        noop     => $ddclient::noops,
      }
    }
    if $ddclient::service != '' {
      monitor::process { 'ddclient_process':
        process  => $ddclient::process,
        service  => $ddclient::service,
        pidfile  => $ddclient::pid_file,
        user     => $ddclient::process_user,
        argument => $ddclient::process_args,
        tool     => $ddclient::monitor_tool,
        enable   => $ddclient::manage_monitor,
        noop     => $ddclient::noops,
      }
    }
  }

  ### Debugging, if enabled ( debug => true )
  if $ddclient::bool_debug == true {
    file { 'debug_ddclient':
      ensure  => $ddclient::manage_file,
      path    => "${settings::vardir}/debug-ddclient",
      mode    => '0640',
      owner   => 'root',
      group   => 'root',
      content => inline_template('<%= scope.to_hash.reject { |k,v| k.to_s =~ /(uptime.*|path|timestamp|free|.*password.*|.*psk.*|.*key)/ }.to_yaml %>'),
      noop    => $ddclient::noops,
    }
  }

}
