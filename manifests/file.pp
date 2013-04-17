#
# Class ddclient::file
#
# This class configures ddclient via a base file
# The file itselt is not provided. Use this class (or, better,
# your custom $my_project class that inherits this) to
# manage the ddclient file in the way you want
#
# It's used if $ddclient_config = "file"
#
class ddclient::file inherits ddclient {

  if $ddclient::manage_file_source or $ddclient::manage_file_template {
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
      noop    => $ddclient::bool_noops,
    }
  }
}
