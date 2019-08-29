require 'spec_helper'

# Check, if configuration was altered

describe file('/etc/graylog/collector-sidecar/collector_sidecar.yml') do
  it { is_expected.to exist }
  it { is_expected.to be_file }
  it { is_expected.to contain('tags: TESTTAG') }
  it { is_expected.to contain('- test') }
end
