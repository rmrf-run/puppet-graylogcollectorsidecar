# Debian-specific handling

class graylogcollectorsidecar::dist::debian (
  $version = 'latest',
  $api_url,
  $tags
) {

  # Fetch download URL from Github Releases for a debian package

  $version_info = loadjson(
    "https://api.github.com/repos/Graylog2/collector-sidecar/releases/$version")

  $version_info['assets'].each |Integer $index, Hash $asset_info|{
    if (
      $asset_info['content_type'] == 'application/x-deb' and
        $asset_info['name'].match(/$architecture/)
    ) {
      $download_url = $asset_info['browser_download_url']
    }
  }

  if (!defined('$download_url')) {
    fail("Can not find a download url for $architecture.")
  }

  # Download the package

  remote_file {
    'get_sidecar_package':
      path   => '/tmp/collector-sidecar.deb',
      source => $download_url
  }

  # Install the package

  package {
    'graylog-sidecar':
      name => 'collector-sidecar',
      ensure => 'installed',
      provider => 'dpkg',
      source => '/tmp/collector-sidecar.deb'
  }

  # Create a sidecar service

  exec {
    'install_sidecar_service':
      creates => '/etc/init/collector-sidecar.conf',
      command => 'graylog-collector-sidecar -service install',
      path => [ '/usr/bin', '/bin' ]
  }

  # Configure it

  class { 'graylogcollectorsidecar::configure':
    sidecar_yaml_file => '/etc/graylog/collector-sidecar/collector_sidecar.yml',
    api_url => $api_url,
    tags => $tags
  }

  # Start the service

  service {
    'sidecar':
      name => 'collector-sidecar',
      ensure => running
  }

  Remote_file['get_sidecar_package']
    -> Package['graylog-sidecar']
    -> Exec['install_sidecar_service']
    -> Class['graylogcollectorsidecar::configure']
    -> Service ['sidecar']

}
