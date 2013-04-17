# Class: ddclient::spec
#
# This class is used only for rpsec-puppet tests
# Can be taken as an example on how to do custom classes but should not
# be modified.
#
# == Usage
#
# This class is not intended to be used directly.
# Use it as reference
#
class ddclient::spec inherits ddclient {

  # This just a test to override the arguments of an existing resource
  # Note that you can achieve this same result with just:
  # class { "ddclient": template => "ddclient/spec.erb" }

  File['ddclient.conf'] {
    content => template('ddclient/spec.erb'),
  }

}
