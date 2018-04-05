require 'spec_helper'

describe 'example::default' do
  let(:custom_root_ca) do
    ::File.read(::File.join('spec', 'fixtures', 'data', 'custom_root_ca.crt'))
  end

  let(:self_signed_example) do
    ::File.read(::File.join('spec', 'fixtures', 'data', 'self_signed_example.crt'))
  end

  before do
    stub_data_bag_item('certs_to_install', 'custom_root_ca').and_return('content' => custom_root_ca)
    stub_data_bag_item('certs_to_install', 'self_signed_example').and_return('content' => self_signed_example)
  end

  context 'debian platform family' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        step_into: 'trusted_certificate'
      ).converge(described_recipe)
    end

    it 'writes certificate to file on disk' do
      expect(chef_run).to create_file('/usr/local/share/ca-certificates/custom_root_ca.crt')
        .with(content: custom_root_ca, owner: 'root', group: 'staff')
      expect(chef_run).to create_file('/usr/local/share/ca-certificates/self_signed_example.crt')
        .with(content: self_signed_example, owner: 'root', group: 'staff')
    end

    it 'updates the OS trust store' do
      execute = chef_run.execute('update trusted certificates')
      expect(execute).to do_nothing

      file = chef_run.file('/usr/local/share/ca-certificates/custom_root_ca.crt')
      expect(file).to notify('execute[update trusted certificates]').to(:run).delayed
    end
  end

  context 'rhel platform family' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'centos',
        version: '6.9',
        step_into: 'trusted_certificate'
      ).converge(described_recipe)
    end

    it 'writes certificate to file on disk' do
      expect(chef_run).to create_file('/etc/pki/ca-trust/source/anchors/custom_root_ca.crt')
        .with(content: custom_root_ca, owner: 'root')
      expect(chef_run).to create_file('/etc/pki/ca-trust/source/anchors/self_signed_example.crt')
        .with(content: self_signed_example, owner: 'root')
    end

    it 'updates the OS trust store' do
      execute = chef_run.execute('update trusted certificates')
      expect(execute).to do_nothing

      file = chef_run.file('/etc/pki/ca-trust/source/anchors/custom_root_ca.crt')
      expect(file).to notify('execute[update trusted certificates]').to(:run).delayed
    end
  end
end

describe 'example::delete' do
  context 'debian platform family' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        step_into: 'trusted_certificate'
      ).converge(described_recipe)
    end

    it 'removes certificate from disk' do
      expect(chef_run).to delete_file('/usr/local/share/ca-certificates/custom_root_ca.crt')
      expect(chef_run).to delete_file('/usr/local/share/ca-certificates/self_signed_example.crt')
    end

    it 'updates the OS trust store' do
      execute = chef_run.execute('update trusted certificates')
      expect(execute).to do_nothing

      file = chef_run.file('/usr/local/share/ca-certificates/custom_root_ca.crt')
      expect(file).to notify('execute[update trusted certificates]').to(:run).delayed
    end
  end

  context 'rhel platform family' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'centos',
        version: '6.9',
        step_into: 'trusted_certificate'
      ).converge(described_recipe)
    end

    it 'removes certificate from disk' do
      expect(chef_run).to delete_file('/etc/pki/ca-trust/source/anchors/custom_root_ca.crt')
      expect(chef_run).to delete_file('/etc/pki/ca-trust/source/anchors/self_signed_example.crt')
    end

    it 'updates the OS trust store' do
      execute = chef_run.execute('update trusted certificates')
      expect(execute).to do_nothing

      file = chef_run.file('/etc/pki/ca-trust/source/anchors/custom_root_ca.crt')
      expect(file).to notify('execute[update trusted certificates]').to(:run).delayed
    end
  end
end
