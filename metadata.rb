name 'trusted_certificate'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache-2.0'
description 'Manages adding certificates to the OS trust store'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '3.2.0'

%w(ubuntu debian redhat centos suse opensuse opensuseleap scientific oracle amazon zlinux).each do |os|
  supports os
end

source_url 'https://github.com/chef-cookbooks/trusted_certificate'
issues_url 'https://github.com/chef-cookbooks/trusted_certificate/issues'
chef_version '>= 12.7' if respond_to?(:chef_version)
