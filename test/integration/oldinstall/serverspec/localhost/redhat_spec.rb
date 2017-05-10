require 'spec_helper'

if %w[redhat].include?(os[:family])

  # Check, that nothing was done

  describe file('/tmp/collector-sidecar.rpm') do
    it { should exist }
  end
  
end