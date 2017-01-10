require 'spec_helper'

describe 'graylogcollectorsidecar' do

  context 'on Debian/amd64' do

    let(:facts) {
      {
          :osfamily => 'Debian',
          :architecture => 'amd64'
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

    it {
      should contain_remote_file('fetch./tmp/collector-sidecar.deb')
    }
    it { should contain_package('graylog-sidecar') }
    it { should contain_service('sidecar') }
    it { should contain_class('graylogcollectorsidecar::configure') }

  end

  context 'on Debian/i386' do

    let(:facts) {
      {
          :osfamily => 'Debian',
          :architecture => 'i386'
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

    it {
      should contain_remote_file('fetch./tmp/collector-sidecar.deb')
    }
    it { should contain_package('graylog-sidecar') }
    it { should contain_service('sidecar') }
    it { should contain_class('graylogcollectorsidecar::configure') }

  end


end
