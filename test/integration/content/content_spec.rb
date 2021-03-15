
certificate_path =
  case os.family
  when 'debian'
    '/usr/local/share/ca-certificates'
  when 'suse'
    '/etc/pki/trust/anchors/'
  else # probably RHEL
    '/etc/pki/ca-trust/source/anchors'
  end

%w(cookbook_file_content inline_content).each do |crt|
  describe file("#{certificate_path}/#{crt}.crt") do
    it { should exist }
    its('content') { should match /-----BEGIN CERTIFICATE-----/ }
  end
end

describe file("#{certificate_path}/remote_content.crt") do
  it { should exist }
end
