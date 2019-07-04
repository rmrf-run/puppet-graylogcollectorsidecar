class graylogcollectorsidecar::configure (
  String $api_url,
  Array[String] $tags,
  Optional[String] $sidecar_yaml_file,
  Optional[Integer] $update_interval,
  Optional[Boolean] $tls_skip_verify,
  Optional[Boolean] $send_status,
  Optional[String] $list_log_files,
  Optional[String] $node_id,
  Optional[String] $collector_id,
  Optional[String] $log_path,
  Optional[String] $log_rotation_time,
  Optional[String] $log_max_age,
  Optional[Tuple]  $backends,
) {

  yaml_setting {
    'sidecar_set_server':
      target => $sidecar_yaml_file,
      key    => 'server_url',
      value  => $api_url,
  }

  yaml_setting {
    'sidecar_set_tags':
      target => $sidecar_yaml_file,
      key    => 'tags',
      value  => $tags,
  }

  # Set defaults

  $_update_interval = pick(
    $update_interval,
    10
  )

  $_tls_skip_verify = pick(
    $tls_skip_verify,
    false
  )

  $_send_status = pick(
    $send_status,
    true
  )

  $_log_rotation_time = pick(
    $log_rotation_time,
    86400
  )

  $_log_max_age = pick(
    $log_max_age,
    604800
  )

  yaml_setting {
    'sidecar_set_update_interval':
      target => $sidecar_yaml_file,
      key    => 'update_interval',
      type   => 'integer',
      value  => $_update_interval,
  } ~> Service['sidecar']

  yaml_setting {
    'sidecar_set_tls_skip_verify':
      target => $sidecar_yaml_file,
      key    => 'tls_skip_verify',
      value  => $_tls_skip_verify,
  } ~> Service['sidecar']

  yaml_setting {
    'sidecar_set_send_status':
      target => $sidecar_yaml_file,
      key    => 'send_status',
      value  => $_send_status,
  } ~> Service['sidecar']

  yaml_setting {
    'sidecar_set_log_rotation_time':
      target => $sidecar_yaml_file,
      key    => 'log_rotation_time',
      type   => 'integer',
      value  => $_log_rotation_time,
  } ~> Service['sidecar']

  yaml_setting {
    'sidecar_set_log_max_age':
      target => $sidecar_yaml_file,
      key    => 'log_max_age',
      type   => 'integer',
      value  => $_log_max_age,
  } ~> Service['sidecar']

  if ($list_log_files) {
    yaml_setting {
      'sidecar_set_list_log_files':
        target => $sidecar_yaml_file,
        key    => 'list_log_files',
        value  => $list_log_files,
    } ~> Service['sidecar']
  }

  if ($node_id) {
    yaml_setting {
      'sidecar_set_node_id':
        target => $sidecar_yaml_file,
        key    => 'node_id',
        value  => $node_id,
    } ~> Service['sidecar']
  }

  if ($collector_id) {
    yaml_setting {
      'sidecar_set_collector_id':
        target => $sidecar_yaml_file,
        key    => 'collector_id',
        value  => $collector_id,
    } ~> Service['sidecar']
  }

  if ($log_path) {
    yaml_setting {
      'sidecar_set_log_path':
        target => $sidecar_yaml_file,
        key    => 'log_path',
        value  => $log_path,
    } ~> Service['sidecar']
  }

  if ($backends) {
    yaml_setting {
      'sidecar_set_backends':
        target => $sidecar_yaml_file,
        key    => 'backends',
        value  => $backends,
    } ~> Service['sidecar']
  }

}