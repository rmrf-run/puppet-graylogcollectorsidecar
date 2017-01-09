# Debian-specific handling

class graylogcollectorsidecar::dist::debian (
  $api_url,
  $tags,
  $version = 'latest'
) {

  if $facts['hardwaremodel'] == 'x86_64' {
    $_arch = 'amd64'
  } else {
    $_arch = 'i386'
  }

  githubreleases::download {
    'get_sidecar_package':
      author            => 'Graylog2',
      repository        => 'collector-sidecar',
      release           => $version,
      asset             => true,
      asset_filepattern => "${_arch}\\.deb",
      target            => '/tmp/graylog-collector-sidecar.deb'
  }

  # Install the package

  package {
    'graylog-sidecar':
      ensure   => 'installed',
      name     => 'collector-sidecar',
      provider => 'dpkg',
      source   => '/tmp/collector-sidecar.deb'
  }

  # Create a sidecar service

  exec {
    'install_sidecar_service':
      creates => '/etc/init/collector-sidecar.conf',
      command => 'graylog-collector-sidecar -service install',
      path    => [ '/usr/bin', '/bin' ]
  }

  # Configure it

  class { 'graylogcollectorsidecar::configure':
    sidecar_yaml_file => '/etc/graylog/collector-sidecar/collector_sidecar.yml',
    api_url           => $api_url,
    tags              => $tags
  }

  # Start the service

  service {
    'sidecar':
      ensure => running,
      name   => 'collector-sidecar'
  }

  Githubreleases::Download['get_sidecar_package']
    -> Package['graylog-sidecar']
    -> Exec['install_sidecar_service']
    -> Class['graylogcollectorsidecar::configure']
    -> Service['sidecar']

}
