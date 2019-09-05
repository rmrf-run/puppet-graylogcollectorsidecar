require 'spec_helper'
require 'socket'

describe 'graylogcollectorsidecar' do
  use_auth = false
  use_oauth = false
  username = ''
  password = ''

  if ENV['GITHUB_USE_AUTH']
    use_auth = true
    username = ENV['GITHUB_USERNAME']
    password = ENV['GITHUB_PASSWORD']
  end

  use_oauth = true if ENV['GITHUB_USE_OAUTH']

  context 'on RedHat/x86_64' do
    let(:facts) do
      {
        osfamily: 'RedHat',
        operatingsystem: 'RedHat',
        operatingsystemmajrelease: '7',
        os: {
          family: 'RedHat',
          release: {
            major: '7',
          },
        },
        architecture: 'x86_64',
        installed_sidecar_version: '',
      }
    end

    let(:params) do
      {
        version: '0.1.0-beta.2',
        api_url: 'http://graylog.example.com',
        log_path: '/var/log/graylog',
        tags: [
          'default',
        ],
        use_auth: use_auth,
        use_oauth: use_oauth,
        username: username,
        password: password,
      }
    end

    it { is_expected.to compile }
    it {
      is_expected.to contain_remote_file('fetch./tmp/collector-sidecar.rpm')
    }
    it { is_expected.to contain_package('graylog-sidecar') }
    it { is_expected.to contain_service('sidecar') }

    expected_content = <<EOT
---
server_url: http://graylog.example.com
update_interval: 10
tls_skip_verify: false
send_status: true
node_id: #{Socket.gethostname}
collector_id: file:/etc/graylog/collector-sidecar/collector-id
cache_path: "/var/cache/graylog/collector-sidecar"
log_path: "/var/log/graylog"
log_rotation_time: 86400
log_max_age: 604800
tags:
- default
backends:
- name: nxlog
  enabled: false
  binary_path: "/usr/bin/nxlog"
  configuration_path: "/etc/graylog/collector-sidecar/generated/nxlog.conf"
- name: filebeat
  enabled: true
  binary_path: "/usr/bin/filebeat"
  configuration_path: "/etc/graylog/collector-sidecar/generated/filebeat.yml"
EOT
    it {
      is_expected.to contain_file('/etc/graylog/collector-sidecar/collector_sidecar.yml').with_content(
        expected_content,
      )
    }
  end

  context 'on RedHat/i386' do
    let(:facts) do
      {
        osfamily: 'RedHat',
        architecture: 'i386',
        operatingsystem: 'RedHat',
        operatingsystemmajrelease: '7',
        os: {
          family: 'RedHat',
          release: {
            major: '7',
          },
        },
        installed_sidecar_version: '',
      }
    end

    let(:params) do
      {
        version: '0.1.0-beta.2',
        api_url: 'http://graylog.example.com',
        tags: [
          'default',
        ],
        use_auth: use_auth,
        use_oauth: use_oauth,
        username: username,
        password: password,
      }
    end

    it {
      is_expected.to contain_remote_file('fetch./tmp/collector-sidecar.rpm')
    }
    it { is_expected.to contain_package('graylog-sidecar') }
    it { is_expected.to contain_service('sidecar') }
  end
end
