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

  context 'on Debian/amd64' do
    let(:facts) do
      {
        osfamily: 'Debian',
        operatingsystem: 'Debian',
        os: {
          family: 'Debian',
        },
        architecture: 'amd64',
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
      is_expected.to contain_remote_file('fetch./tmp/collector-sidecar.deb')
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

  context 'on Debian/i386' do
    let(:facts) do
      {
        osfamily: 'Debian',
        operatingsystem: 'Debian',
        os: {
          family: 'Debian',
        },
        architecture: 'i386',
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
      is_expected.to contain_remote_file('fetch./tmp/collector-sidecar.deb')
    }
    it { is_expected.to contain_package('graylog-sidecar') }
    it { is_expected.to contain_service('sidecar') }
  end
end
