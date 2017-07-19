require 'spec_helper'

if %w[debian].include?(os[:family])

  # Check, if configuration was altered

  describe file('/etc/graylog/collector-sidecar/collector_sidecar.yml') do
    it { should exist }
    it { should be_file }
    it { should contain('- TESTTAG') }
    it { should_not contain('- test') }
  end

end