class graylogcollectorsidecar::configure (
  $sidecar_yaml_file,
  $api_url,
  $tags,
  $update_interval,
  $tls_skip_verify,
  $send_status,
  $list_log_files,
  $node_id,
  $collector_id,
  $log_path,
  $log_rotation_time,
  $log_max_age
) {
  yaml_setting {
    'sidecar_set_server':
      target => $sidecar_yaml_file,
      key    => 'server_url',
      value  => $api_url
  }

  yaml_setting {
    'sidecar_set_tags':
      target => $sidecar_yaml_file,
      key    => 'tags',
      value  => $tags
  }

  if ($update_interval) {
    yaml_setting {
      'sidecar_set_update_interval':
        target => $sidecar_yaml_file,
        key    => 'update_interval',
        value  => $update_interval
    }
  }

  if ($tls_skip_verify) {
    yaml_setting {
      'sidecar_set_tls_skip_verify':
        target => $sidecar_yaml_file,
        key    => 'tls_skip_verify',
        value  => $tls_skip_verify
    }
  }

  if ($send_status) {
    yaml_setting {
      'sidecar_set_send_status':
        target => $sidecar_yaml_file,
        key    => 'send_status',
        value  => $send_status
    }
  }

  if ($list_log_files) {
    yaml_setting {
      'sidecar_set_list_log_files':
        target => $sidecar_yaml_file,
        key    => 'list_log_files',
        value  => $list_log_files
    }
  }

  if ($node_id) {
    yaml_setting {
      'sidecar_set_node_id':
        target => $sidecar_yaml_file,
        key    => 'node_id',
        value  => $node_id
    }
  }

  if ($collector_id) {
    yaml_setting {
      'sidecar_set_collector_id':
        target => $sidecar_yaml_file,
        key    => 'collector_id',
        value  => $collector_id
    }
  }

  if ($log_path) {
    yaml_setting {
      'sidecar_set_log_path':
        target => $sidecar_yaml_file,
        key    => 'log_path',
        value  => $log_path
    }
  }

  if ($log_rotation_time) {
    yaml_setting {
      'sidecar_set_log_rotation_time':
        target => $sidecar_yaml_file,
        key    => 'log_rotation_time',
        value  => $log_rotation_time
    }
  }

  if ($log_max_age) {
    yaml_setting {
      'sidecar_set_log_max_age':
        target => $sidecar_yaml_file,
        key    => 'log_max_age',
        value  => $log_max_age
    }
  }

}