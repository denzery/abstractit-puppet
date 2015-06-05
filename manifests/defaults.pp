# Class: puppet::defaults
#
# This class manages OS specific variables for
#
# Parameters:
# - The $puppet_pkgs for each OS
#
# Actions:
#
# Requires:
#
# Sample Usage:
#

class puppet::defaults {
  case $::osfamily {
    'Debian' : {
      $puppetmaster_pkg   = 'puppetmaster'
      $sysconfigdir       = '/etc/default'
    }
    'RedHat' : {
      $puppetmaster_pkg   = 'puppet-server'
      $sysconfigdir       = '/etc/sysconfig'
    }
    default  : {
      fail("Class['puppet::defaults']: Unsupported osfamily: ${::osfamily}")
    }
  }

  if ( versioncmp($::puppetversion, '4.0.0') >= 0 ) {
    $server_type     = 'puppetserver'
    $confdir         = '/etc/puppetlabs/puppet'
    $codedir         = '/etc/puppetlabs/code'
    $environmentpath = "${codedir}/environments"
    $basemodulepath  = "${codedir}/modules:${confdir}/modules"
    $hieradata_path  = "${codedir}/hieradata"
    $hiera_backends  = {
      'yaml' => {
        'datadir' => '/etc/puppetlabs/code/hieradata/%{environment}'
      }
    }
    $facterbasepath = '/opt/puppetlabs/facter'
  } else {
    $server_type     = 'passenger'
    $confdir         = '/etc/puppet'
    $codedir         = '/etc/puppet'
    $environmentpath = "${codedir}/environments"
    $basemodulepath  = "${confdir}/modules:/usr/share/puppet/modules"
    $hieradata_path  = "${confdir}/hieradata"
    $hiera_backends  = {
      'yaml' => {
        'datadir' => '/etc/puppet/hieradata/%{environment}'
      }
    }
    $facterbasepath  = '/etc/facter'
  }
}