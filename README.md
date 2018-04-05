# trusted_certificate cookbook

[![Build Status](https://travis-ci.org/chef-cookbooks/trusted_certificate.svg?branch=master)](https://travis-ci.org/chef-cookbooks/trusted_certificate) [![Cookbook Version](https://img.shields.io/cookbook/v/trusted_certificate.svg)](https://supermarket.chef.io/cookbooks/trusted_certificate)

This cookbook provides a `trusted_certificate` resource to manage adding SSL/TLS certificates to the operating system's trust store.

## Requirements

### Platforms

- Debian/Ubuntu
- RHEL 6+

### Chef

- Chef 12.7+

### Cookbooks

- none

## Recipes

### default

Installs the `ca-certificates` package that provides the certificate trust mechanism.

## Resources

### trusted_certificate

Adds a certificate to the operating system's trust store.

#### properties

- `content`: The contents of the cert to add
- `certificate_name`: The filename of the cert

#### actions

- `create`
- `delete`

#### example

```ruby
trusted_certificate 'my_corp' do
  action :create
  content 'THIS_WOULD_BE_THE_WHOLE_CERT_CONTENTS'
end
```

```ruby
trusted_certificate 'my_corp' do
  action :delete
end
```
## Testing

This cookbook has the following [ChefSpec custom matcher](https://github.com/sethvargo/chefspec#packaging-custom-matchers) defined:

- create_trusted_certificate

## License & Authors

**Author:** Cookbook Engineering Team ([cookbooks@chef.io](mailto:cookbooks@chef.io))

**Copyright:** 2008-2016, Chef Software, Inc.

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
