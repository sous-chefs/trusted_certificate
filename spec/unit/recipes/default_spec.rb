require 'spec_helper'

describe 'trusted_certificate::default' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'installs ca-certificates' do
    expect(chef_run).to install_package('ca-certificates')
  end
end
