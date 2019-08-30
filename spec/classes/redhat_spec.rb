require 'spec_helper'

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
    it {
      is_expected.to contain_yaml_setting('sidecar_set_server').with_value('http://graylog.example.com')
    }
    it { is_expected.to contain_yaml_setting('sidecar_set_tags') }
    it { is_expected.to contain_yaml_setting('sidecar_set_log_path') }
    it { is_expected.not_to contain_yaml_setting('sidecar_set_list_log_files') }
    it { is_expected.to contain_yaml_setting('sidecar_set_backends') }
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
