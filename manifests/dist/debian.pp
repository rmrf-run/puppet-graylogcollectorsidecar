# Debian-specific handling

class graylogcollectorsidecar::dist::debian (
  String $api_url,
  String $tags,
  String $username,
  String $password,
  Boolean $use_auth          = true,
  Integer $update_interval   = undef,
  Boolean $tls_skip_verify   = undef,
  Boolean $send_status       = undef,
  String $list_log_files     = undef,
  String $node_id            = undef,
  String $collector_id       = undef,
  String $log_path           = undef,
  Integer $log_rotation_time = undef,
  Integer $log_max_age       = undef,
  String $backends           = undef,
  String $version            = 'latest',
) {

  if ($::installed_sidecar_version == $version) {
    debug("Already installed sidecard version ${version}")
  } else {
    # Download package

    # Versions have to be downloaded using tags, the latest release not (https://github.com/dodevops/puppet-graylogcollectorsidecar/issues/2)
    if $version == 'latest' {
      $is_tag = false
    } else {
      $is_tag = true
    }

    githubreleases::download {
      'get_sidecar_package':
        author            => 'Graylog2',
        repository        => 'collector-sidecar',
        release           => $version,
        is_tag            => $is_tag,
        asset             => true,
        asset_filepattern => "${::architecture}\\.deb",
        target            => '/tmp/collector-sidecar.deb',
        use_auth          => $use_auth,
        username          => $username,
        password          => $password,
    }

    # Install the package

    package {
      'graylog-sidecar':
        ensure   => 'installed',
        name     => 'collector-sidecar',
        provider => 'dpkg',
        source   => '/tmp/collector-sidecar.deb',
    }

    # Create a sidecar service

    exec {
      'install_sidecar_service':
        creates => '/etc/init/collector-sidecar.conf',
        command => 'graylog-collector-sidecar -service install',
        path    => [ '/usr/bin', '/bin' ],
    }

    Githubreleases::Download['get_sidecar_package']
    -> Package['graylog-sidecar']
    -> Exec['install_sidecar_service']
    -> Class['graylogcollectorsidecar::configure']
    -> Service['sidecar']

  }

  # Configure it

  $_collector_id = pick(
    $collector_id,
    'file:/etc/graylog/collector-sidecar/collector-id'
  )

  $_log_path = pick(
    $log_path,
    '/var/log/graylog/collector-sidecar'
  )

  $_backends = pick(
    $backends,
    [
      {
        name               => 'nxlog',
        enabled            => false,
        binary_path        => '/usr/bin/nxlog',
        configuration_path =>
        '/etc/graylog/collector-sidecar/generated/nxlog.conf',
      },
      {
        name               => 'filebeat',
        enabled            => true,
        binary_path        => '/usr/bin/filebeat',
        configuration_path =>
        '/etc/graylog/collector-sidecar/generated/filebeat.yml',
      },
    ]
  )

  class { '::graylogcollectorsidecar::configure':
    sidecar_yaml_file =>
      '/etc/graylog/collector-sidecar/collector_sidecar.yml',
    api_url           => $api_url,
    tags              => $tags,
    update_interval   => $update_interval,
    tls_skip_verify   => $tls_skip_verify,
    send_status       => $send_status,
    list_log_files    => $list_log_files,
    node_id           => $node_id,
    collector_id      => $_collector_id,
    log_path          => $_log_path,
    log_rotation_time => $log_rotation_time,
    log_max_age       => $log_max_age,
    backends          => $_backends,
  } ~> Service['sidecar']

  # Start the service

  service {
    'sidecar':
      ensure => running,
      name   => 'collector-sidecar',
  }

}
