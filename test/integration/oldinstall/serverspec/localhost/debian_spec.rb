require 'spec_helper'

if ['ubuntu'].include?(os[:family])

  # Check, that nothing was done

  describe file('/tmp/collector-sidecar.deb') do
    it { is_expected.to exist }
  end
end
