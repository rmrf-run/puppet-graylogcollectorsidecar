require 'spec_helper'
describe 'graylogcollectorsidecar' do
  context 'with default values for all parameters' do
    it { should contain_class('graylogcollectorsidecar') }
  end
end
