require 'spec_helper'

if ['redhat'].include?(os[:family])

  # Check, that nothing was done

  describe file('/tmp/collector-sidecar.rpm') do
    it { is_expected.not_to exist }
  end

end
