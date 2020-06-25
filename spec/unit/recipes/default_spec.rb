require 'chefspec'

describe 'trusted_certificate::default' do
  platform 'centos', '7'

  it { is_expected.to install_package('ca-certificates') }
end
