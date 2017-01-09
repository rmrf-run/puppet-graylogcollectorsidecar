require 'spec_helper'

describe 'graylogcollectorsidecar' do

  context 'on Debian' do
    let(:facts) {
      {
          :osfamily => 'Debian'
      }
    }

    let(:params) {
      {
          :version => '0.1.0-beta.2',
          :api_url => 'http://graylog.example.com',
          :tags => [
              'default'
          ]
      }
    }

    it { should contain_remote_file('fetch./tmp/graylog-collector-sidecar.deb') }
    it { should contain_package('graylog-sidecar') }
    it { should contain_service('sidecar') }
    it { should contain_class('graylogcollectorsidecar::configure') }
  end

end
