require 'spec_helper'
describe 'nvidia' do
  context 'with default values for all parameters' do
    it { should contain_class('hashcat') }
  end
end
