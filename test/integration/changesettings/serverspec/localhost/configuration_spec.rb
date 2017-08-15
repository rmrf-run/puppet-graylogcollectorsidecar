require 'spec_helper'

# Check, if configuration was altered

describe file('/etc/graylog/collector-sidecar/collector_sidecar.yml') do
  it { should exist }
  it { should be_file }
  it { should contain('tags: TESTTAG') }
  it { should_not contain('- test') }
end