# frozen_string_literal: true

certificate_path =
  case os.family
  when 'debian'
    '/usr/local/share/ca-certificates'
  when 'suse'
    '/etc/pki/trust/anchors/'
  else
    '/etc/pki/ca-trust/source/anchors'
  end

control 'trusted-certificate-content-01' do
  impact 1.0
  title 'Cookbook file and inline certificates are installed'

  %w(cookbook_file_content inline_content).each do |crt|
    describe file("#{certificate_path}/#{crt}.crt") do
      it { should exist }
      its('content') { should match /-----BEGIN CERTIFICATE-----/ }
    end
  end
end

control 'trusted-certificate-content-02' do
  impact 1.0
  title 'Remote certificate is installed'

  describe file("#{certificate_path}/remote_content.crt") do
    it { should exist }
  end
end
