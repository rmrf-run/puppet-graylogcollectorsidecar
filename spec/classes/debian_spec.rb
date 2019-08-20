require 'spec_helper'

describe 'graylogcollectorsidecar' do

  context 'on Debian/amd64' do

    let(:facts) {
      {
          :osfamily => 'Debian',
          :architecture => 'amd64',
          :installed_sidecar_version => ''
      }
    }

    let(:params) {
      {
          :version => '0.1.0-beta.2',
          :api_url => 'http://graylog.example.com',
          :log_path => '/var/log/graylog',
          :tags => [
              'default'
          ],
          :use_auth => ENV.has_key?('TEST_USERNAME'),
          :username => ENV['TEST_USERNAME'],
          :password => ENV['TEST_PASSWORD'],
      }
    }

    it { should compile }
    it {
      should contain_remote_file('fetch./tmp/collector-sidecar.deb')
    }
    it { should contain_package('graylog-sidecar') }
    it { should contain_service('sidecar') }
    it { should contain_class('graylogcollectorsidecar::configure') }
    it {
      should contain_yaml_setting('sidecar_set_server')
                 .with_value('http://graylog.example.com')
    }
    it { should contain_yaml_setting('sidecar_set_tags') }
    it { should contain_yaml_setting('sidecar_set_log_path') }
    it { should_not contain_yaml_setting('sidecar_set_list_log_files') }
    it { should contain_yaml_setting('sidecar_set_backends')}

  end

  context 'on Debian/i386' do

    let(:facts) {
      {
          :osfamily => 'Debian',
          :architecture => 'i386',
          :installed_sidecar_version => ''
      }
    }

    let(:params) {
      {
          :version => '0.1.0-beta.2',
          :api_url => 'http://graylog.example.com',
          :tags => [
              'default'
          ],
          :use_auth => ENV.has_key?('TEST_USERNAME'),
          :username => ENV['TEST_USERNAME'],
          :password => ENV['TEST_PASSWORD'],
      }
    }

    it {
      should contain_remote_file('fetch./tmp/collector-sidecar.deb')
    }
    it { should contain_package('graylog-sidecar') }
    it { should contain_service('sidecar') }
    it { should contain_class('graylogcollectorsidecar::configure') }

  end


end
