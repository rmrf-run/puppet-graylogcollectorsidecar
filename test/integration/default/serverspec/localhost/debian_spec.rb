require 'spec_helper'

if ['debian', 'ubuntu'].include?(os[:family])

  # Check configuration

  describe file('/etc/graylog/collector-sidecar/collector_sidecar.yml') do
    it { should exist }
    it { should be_file }
    it { should contain('TESTTAG') }
    it { should contain('tls_skip_verify: true')}
    it { should contain('log_max_age: 4711')}
    it { should contain('log_rotation_time: 86400')}
  end

  # Check service

  describe service('collector-sidecar') do
    it { should be_enabled }
    it { should be_running }
  end

end