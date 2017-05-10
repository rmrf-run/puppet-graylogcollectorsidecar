require 'spec_helper'

if %w[debian].include?(os[:family])

  # Check configuration

  describe file('/etc/graylog/collector-sidecar/collector_sidecar.yml') do
    it { should exist }
    it { should be_file }
    it { should contain('TESTTAG') }
    it { should contain('tls_skip_verify: true')}
  end

  # Check service

  describe service('collector-sidecar') do
    it { should be_enabled }
    it { should be_running }
  end

end