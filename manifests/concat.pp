#
# Class ddclient::concat
#
# This class builds the ddclient hosts.local file using RIPienaar's concat module
# We build it using several fragments.
# Being the sequence of lines important we define these boundaries:
# 01 - General header
# Note that the ddclient::host define
# inserts (by default) its rules with priority 50.
#
class ddclient::concat {

  include ddclient
  include concat::setup

  concat { $ddclient::config_file:
    mode    => $ddclient::config_file_mode,
    owner   => $ddclient::config_file_owner,
    group   => $ddclient::config_file_group,
    notify  => Service['ddclient'],
  }

  # The File Header. With Puppet comment
  concat::fragment{ 'ddclient_header':
    target  => $ddclient::config_file,
    content => "# File Managed by Puppet\n",
    order   => 01,
    notify  => Service['ddclient'],
  }

  # The DEFAULT header with the default policies
  concat::fragment{ 'ddclient_hosts_header':
    target  => $ddclient::config_file,
    content => template($ddclient::hosts_template_header),
    order   => 05,
    notify  => Service['ddclient'],
  }

  # The host.local footer
  concat::fragment{ 'ddclient_hosts_footer':
    target  => $ddclient::config_file,
    content => template($ddclient::hosts_template_footer),
    order   => 99,
    notify  => Service['ddclient'],
  }
}
