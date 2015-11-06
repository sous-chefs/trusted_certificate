require 'spec_helper'

describe 'example::default' do
  let(:custom_root_ca) do
    ::File.read(::File.join('spec', 'fixtures', 'data', 'custom_root_ca.crt'))
  end

  let(:self_signed_example) do
    ::File.read(::File.join('spec', 'fixtures', 'data', 'self_signed_example.crt'))
  end

  let(:custom_root_ca_file) do
    '/usr/local/share/ca-certificates/custom_root_ca.crt'
  end

  let(:self_signed_example_file) do
    '/usr/local/share/ca-certificates/self_signed_example.crt'
  end

  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '14.04',
      step_into: 'trusted_certificate'
    ).converge(described_recipe)
  end

  before do
    stub_data_bag_item('certs_to_install', 'custom_root_ca').and_return('content' => custom_root_ca)
    stub_data_bag_item('certs_to_install', 'self_signed_example').and_return('content' => self_signed_example)
  end

  it 'writes certificate to file on disk' do
    expect(chef_run).to create_file(custom_root_ca_file)
      .with(content: custom_root_ca, owner: 'root', group: 'staff')
    expect(chef_run).to create_file(self_signed_example_file)
      .with(content: self_signed_example, owner: 'root', group: 'staff')
  end

  it 'updates the OS trust store' do
    execute = chef_run.execute('update-ca-certificates')
    expect(execute).to do_nothing

    file = chef_run.file(custom_root_ca_file)
    expect(file).to notify('execute[update-ca-certificates]').to(:run).delayed
  end
end
