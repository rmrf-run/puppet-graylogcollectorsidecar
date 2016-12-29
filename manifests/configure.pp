class graylogcollectorsidecar::configure (
  $sidecar_yaml_file,
  $api_url,
  $tags
) {
  yaml_setting {
    'sidecar_set_server':
      target => $sidecar_yaml_file,
      key => 'server_url',
      value => $api_url
  }

  yaml_setting {
    'sidecar_set_tags':
      target => $sidecar_yaml_file,
      key => 'tags',
      value => $tags
  }
}