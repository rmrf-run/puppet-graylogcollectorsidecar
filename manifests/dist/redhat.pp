# RedHat-specific handling

class graylogcollectorsidecar::dist::redhat (
  String $api_url,
  Array[String] $tags,
  String $username,
  String $password,
  String $version                      = 'latest',
  Optional[Boolean] $use_auth          = true,
  Optional[Integer] $update_interval   = undef,
  Optional[Boolean] $tls_skip_verify   = undef,
  Optional[Boolean] $send_status       = undef,
  Optional[String] $list_log_files     = undef,
  Optional[String] $node_id            = undef,
  Optional[String] $collector_id       = undef,
  Optional[String] $log_path           = undef,
  Optional[String] $log_rotation_time  = undef,
  Optional[String] $log_max_age        = undef,
  Optional[Tuple] $backends            = undef,
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
        asset_filepattern => "${::architecture}\\.rpm",
        target            => '/tmp/collector-sidecar.rpm',
        use_auth          => $use_auth,
        username          => $username,
        password          => $password,
    }

    # Install the package

    package {
      'graylog-sidecar':
        ensure   => 'installed',
        name     => 'collector-sidecar',
        provider => 'rpm',
        source   => '/tmp/collector-sidecar.rpm',
    }

    # Create a sidecar service

    case downcase($::operatingsystemmajrelease) {

      '7': {
        $check_creates = '/etc/systemd/system/collector-sidecar.service'
      }

      default: {
        $check_creates = '/etc/init/collector-sidecar.conf'
      }
    }

    exec {
      'install_sidecar_service':
        creates => $check_creates,
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
