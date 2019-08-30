$_use_auth = $facts['github_use_auth'] ? {
  # lint:ignore:quoted_booleans
  'true'  => true,
  # lint:endignore
  default => false,
}

$_use_oauth = $facts['github_use_oauth'] ? {
  # lint:ignore:quoted_booleans
  'true'  => true,
  # lint:endignore
  default => false,
}

class {
  '::graylogcollectorsidecar':
    api_url         => 'https://graylog.company.com',
    version         => '0.1.0',
    tags            => [
      'TESTTAG',
    ],
    tls_skip_verify => true,
    log_max_age     => 4711,
    use_auth        => $_use_auth,
    use_oauth       => $_use_oauth,
    username        => $facts['github_username'],
    password        => $facts['github_password'],
}
