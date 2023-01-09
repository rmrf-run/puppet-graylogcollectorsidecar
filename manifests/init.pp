# @summary Installs and configures graylog-collector-sidecar
# @see https://github.com/Graylog2/collector-sidecar Graylog-Collector package
# @see https://docs.graylog.org/en/2.4/pages/collector_sidecar.html Graylog-Collector documentation
# @param api_url URL to the Graylog server
# @param tags Array of tags to set in the collector sidecar configuration
# @param version Version of the collector to ensure
# @param use_auth Use authentication for Github
# @param use_oauth Use OAuth instead of basic authentication for Github
# @param username Username for Github
# @param password Password for Github
# @param update_interval Graylog-Collector sidecar configuration item "update_interval". Check docs for info.
# @param tls_skip_verify Graylog-Collector sidecar configuration item "tls_skip_verify". Check docs for info.
# @param send_status Graylog-Collector sidecar configuration item "send_status". Check docs for info.
# @param node_id Graylog-Collector sidecar configuration item "node_id". Check docs for info.
# @param collector_id Graylog-Collector sidecar configuration item "collector_id". Check docs for info.
# @param cache_path Graylog-Collector sidecar configuration item "cache_path". Check docs for info.
# @param log_path Graylog-Collector sidecar configuration item "log_path". Check docs for info.
# @param log_rotation_time Graylog-Collector sidecar configuration item "log_rotation_time". Check docs for info.
# @param log_max_age Graylog-Collector sidecar configuration item "log_max_age". Check docs for info.
# @param backends Graylog-Collector sidecar configuration item "backends". Check docs for info.
# @param service_creates Using graylog-collector to install the service creates this file [internal]
# @param sidecar_yaml_file Filename of the sidecar configuration yaml [internal]
# @param list_log_files Graylog-Collector sidecar configuration item "list_log_files". Check docs for info.
# @param package_suffix The file suffix for the package file [internal]
# @param package_provider The package provider used to install the package [internal]
class graylogcollectorsidecar (
  String $api_url,
  Array[String] $tags,
  String $version,
  Variant[Boolean, String] $use_auth,
  Variant[Boolean, String] $use_oauth,
  String $username,
  String $password,
  Integer $update_interval,
  Boolean $tls_skip_verify,
  Boolean $send_status,
  String $node_id,
  String $collector_id,
  String $cache_path,
  String $log_path,
  Integer $log_rotation_time,
  Integer $log_max_age,
  Array[Hash] $backends,
  String $service_creates,
  String $sidecar_yaml_file,
  Optional[Array[String]] $list_log_files = undef,
  Optional[String] $package_suffix        = undef,
  Optional[String] $package_provider      = undef,
) {

  if (!$package_suffix or !$package_provider) {
    warning('OS currently not supported by the graylog collector sidecar module')
  }

  $_require_config = $::installed_sidecar_version ? {
    $version => undef,
    default  => Package['graylog-sidecar']
  }

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

    githubreleases_download {
      "/tmp/collector-sidecar.${package_suffix}":
        author            => 'Graylog2',
        repository        => 'collector-sidecar',
        release           => $version,
        is_tag            => $is_tag,
        asset             => true,
        asset_filepattern => "${::architecture}\\.${package_suffix}",
        use_auth          => $use_auth,
        use_oauth         => $use_oauth,
        username          => $username,
        password          => $password,
    }

    # Install the package

    -> package {
      'graylog-sidecar':
        ensure   => 'installed',
        name     => 'collector-sidecar',
        provider => $package_provider,
        source   => "/tmp/collector-sidecar.${package_suffix}",
    }

    # Create a sidecar service

    -> exec {
      'install_sidecar_service':
        creates => $service_creates,
        command => 'graylog-collector-sidecar -service install',
        path    => [ '/usr/bin', '/bin' ],
        before  => Service['sidecar']
    }
  }

  # Configure it

  $_list_log_files_addition = $list_log_files ? {
    undef   => {},
    default => {
      list_log_files => $list_log_files
    }
  }

  $_configuration = {
    server_url        => $api_url,
    update_interval   => $update_interval,
    tls_skip_verify   => $tls_skip_verify,
    send_status       => $send_status,
    node_id           => $node_id,
    collector_id      => $collector_id,
    cache_path        => $cache_path,
    log_path          => $log_path,
    log_rotation_time => $log_rotation_time,
    log_max_age       => $log_max_age,
    tags              => $tags,
    backends          => $backends,
  } + $_list_log_files_addition

  file {
    $sidecar_yaml_file:
      ensure  => 'present',
      content => hash2yaml($_configuration),
      require => $_require_config
  }

  # Start the service

  service {
    'sidecar':
      ensure => 'running',
      name   => 'collector-sidecar',
  }

}
