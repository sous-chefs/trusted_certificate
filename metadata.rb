name 'trusted_certificate'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache 2.0'
description 'Manages adding and removing certificates from the OS trust store'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'

supports 'debian'
supports 'ubuntu'

source_url 'https://github.com/chef-cookbooks/trusted_certificate'
issues_url 'https://github.com/chef-cookbooks/trusted_certificate/issues'

chef_version '>= 12.1' if respond_to?(:chef_version)
