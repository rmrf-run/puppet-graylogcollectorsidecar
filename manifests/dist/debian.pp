# Debian-specific handling

class graylogcollectorsidecar::dist::debian (
  $api_url,
  $tags,
  $update_interval   = undef,
  $tls_skip_verify   = undef,
  $send_status       = undef,
  $list_log_files    = undef,
  $node_id           = undef,
  $collector_id      = undef,
  $log_path          = undef,
  $log_rotation_time = undef,
  $log_max_age       = undef,
  $version           = 'latest'
) {

  # Download package

  githubreleases::download {
    'get_sidecar_package':
      author            => 'Graylog2',
      repository        => 'collector-sidecar',
      release           => $version,
      is_tag            => true,
      asset             => true,
      asset_filepattern => "${::architecture}\\.deb",
      target            => '/tmp/collector-sidecar.deb'
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
    tags              => $tags,
    update_interval   => $update_interval,
    tls_skip_verify   => $tls_skip_verify,
    send_status       => $send_status,
    list_log_files    => $list_log_files,
    node_id           => $node_id,
    collector_id      => $collector_id,
    log_path          => $log_path,
    log_rotation_time => $log_rotation_time,
    log_max_age       => $log_max_age
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
