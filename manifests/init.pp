# == Class: puppetmaster
#
# This class installs and configures Puppet Master
#
# === Parameters
#
# [*puppetmaster_package_ensure*]
#   Specify the package update state. Defaults to 'present'. Possible value is 'latest'.
#
# [*puppetmaster_service_ensure*]
#   Specify the service running state. Defaults to 'running'. Possible value is 'stopped'.
#
# [*puppetmaster_service_enable*]
#   Specify the service enable state. Defaults to 'true'. Possible value is 'false'.
#
# [*puppetmaster_server*]
#   Specify the Puppet Master server name.
#
# [*certname*]
#   Specify the Puppet Master certificate name. It is usually the server hostname.
#
# [*puppetmaster_report*]
#   Send reports after every transction. Defaults to 'true'. Possible value is 'false'.
#
# [*autosign*]
#   Whether to enable autosign. Defaults to 'false'. Possible value is 'true' or file path.
#
# [*puppetmaster_reports*]
#   List of reports to generate. See documentation for possible values.
#
# [*puppetmaster_reporturl*]
#   The URL used by the http reports processor to send reports.
#
# [*puppetmaster_facts_terminus*]
#   The node facts terminus. Default to facter. Possible value is 'PuppetDB'.
#
# [*modulepath*]
#   Defines the module path.
#
# === Variables
#
# === Examples
#
#  class { puppetmaster:
#    puppetmaster_server               => 'puppet1.puppet.test',
#    certname                          => 'puppet1.puppet.test',
#    puppetmaster_report               => 'true',
#    autosign             => 'true',
#    puppetmaster_reports              => 'store, http',
#    puppetmaster_reporturl            => 'http://puppet1.puppet.test:8080/reports/upload',
#    puppetmaster_facts_terminus       => 'PuppetDB',
#    modulepath                        => '$confdir/modules:$confdir/modules-0',
#  }
#
# === Authors
#
# Felipe Salum <fsalum@gmail.com>
#
# === Copyright
#
# Copyright 2012 Felipe Salum, unless otherwise noted.
#
class puppetmaster (
  $puppetmaster_package_ensure       = 'present',
  $puppetmaster_service_ensure       = 'running',
  $puppetmaster_service_enable       = 'true',
  $puppetmaster_server               = '',
  $puppetmaster_report               = undef,
  $autosign                          = undef,
  $puppetmaster_reports              = '',
  $puppetmaster_reporturl            = '',
  $puppetmaster_facts_terminus       = '',
  $modulepath                        = '',
  $logdir                            = undef,
  $vardir                            = undef,
  $ssldir                            = undef,
  $rundir                            = undef,
  $factpath                          = undef,
  $templatedir                       = undef,
  $ssl_client_header                 = undef,
  $ssl_client_verify_header          = undef,
  $dns_alt_names                     = undef,
  $certname                          = undef,
  $storeconfigs                      = undef,
  $storeconfigs_backend              = undef,
  
) {

  include puppetmaster::params

  $puppetmaster_package_name = $puppetmaster::params::puppetmaster_package_name
  $puppetmaster_service_name = $puppetmaster::params::puppetmaster_service_name

  package { $puppetmaster_package_name:
    ensure  => $puppetmaster_package_ensure,
  }

  # We will need to restart the puppet master service if certain config
  # files are changed, so here we make sure it's in the catalog.
  if ! defined(Service[$puppetmaster_service_name]) {
    service { $puppetmaster_service_name:
      ensure     => $puppetmaster_service_ensure,
      enable     => $puppetmaster_service_enable,
      hasrestart => true,
      hasstatus  => true,
      require    => Package[$puppetmaster_package_name],
    }
  }

  Ini_setting {
    path    => '/etc/puppet/puppet.conf',
    ensure  => present,
  }

  if $ssl_client_verify_header {
    ini_setting { 'ssl_client_verify_header':
      section => 'master',
      setting => 'ssl_client_verify_header',
      value   => $ssl_client_verify_header,
    }
  }

  if $ssl_client_header {
    ini_setting { 'ssl_client_header':
      section => 'master',
      setting => 'ssl_client_header',
      value   => $ssl_client_header,
    }
  }

  if $dns_alt_names {
    ini_setting { 'dns_alt_names':
      section => 'master',
      setting => 'dns_alt_names',
      value   => $dns_alt_names,
    }
  }

  if $storeconfigs_backend {
    ini_setting { 'storeconfigs_backend':
      section => 'master',
      setting => 'storeconfigs_backend',
      value   => $storeconfigs_backend,
    }
  }

  if $storeconfigs {
    ini_setting { 'storeconfigs':
      section => 'master',
      setting => 'storeconfigs',
      value   => $storeconfigs,
    }
  }

  if $templatedir {
    ini_setting { 'templatedir':
      section => 'main',
      setting => 'templatedir',
      value   => $templatedir,
    }
  }

  if $factpath {
    ini_setting { 'factpath':
      section => 'main',
      setting => 'factpath',
      value   => $factpath,
    }
  }

  if $rundir {
    ini_setting { 'rundir':
      section => 'main',
      setting => 'rundir',
      value   => $rundir,
    }
  }

  if $ssldir {
    ini_setting { 'ssldir':
      section => 'main',
      setting => 'ssldir',
      value   => $ssldir,
    }
  }

  if $logdir {
    ini_setting { 'logdir':
      section => 'main',
      setting => 'logdir',
      value   => $logdir,
    }
  }

  if $vardir {
    ini_setting { 'vardir':
      section => 'main',
      setting => 'vardir',
      value   => $vardir,
    }
  }

  if $modulepath {
    ini_setting { 'modulepath':
      section => 'main',
      setting => 'modulepath',
      value   => $modulepath,
    }
  }

  if $puppetmaster_server {
    ini_setting { 'puppetmaster_server':
      section => 'main',
      setting => 'server',
      value   => $puppetmaster_server,
    }
  }

  if $puppetmaster_report {
    ini_setting { 'puppetmaster_report':
      section => 'agent',
      setting => 'report',
      value   => $puppetmaster_report,
    }
  }

  if $certname {
    ini_setting { 'certname':
      section => 'master',
      setting => 'certname',
      value   => $certname,
    }
  }

  if $autosign {
    ini_setting { 'autosign':
      section => 'master',
      setting => 'autosign',
      value   => $autosign,
    }
  }

  if $puppetmaster_reports {
    ini_setting { 'puppetmaster_reports':
      section => 'master',
      setting => 'reports',
      value   => $puppetmaster_reports,
    }
  }

  if $puppetmaster_reporturl {
    ini_setting { 'puppetmaster_reporturl':
      section => 'master',
      setting => 'reporturl',
      value   => $puppetmaster_reporturl,
    }
  }

  if $puppetmaster_facts_terminus {
    ini_setting { 'puppetmaster_facts_terminus':
      section => 'master',
      setting => 'facts_terminus',
      value   => $puppetmaster_facts_terminus,
    }
  }

}
