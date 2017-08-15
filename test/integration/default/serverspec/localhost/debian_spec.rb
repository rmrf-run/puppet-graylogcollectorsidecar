require 'spec_helper'
require 'socket'

if %w[ubuntu].include?(os[:family])

  # Check configuration

  describe file('/etc/graylog/collector-sidecar/collector_sidecar.yml') do
    it { should exist }
    it { should be_file }
    it { should contain('TESTTAG') }
    its(:content_as_yaml) { should include('tls_skip_verify' => true) }
    its(:content_as_yaml) { should include('log_max_age' => 4711) }
    its(:content_as_yaml) { should include('log_rotation_time' => 86400) }
    its(:content_as_yaml) { should include('backends') }
    its(:content_as_yaml) { should include('node_id' => Socket.gethostname) }
  end

  # Check service

  describe service('collector-sidecar') do
    it { should be_enabled }
    it { should be_running }
  end

end