# trusted_certificate cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/trusted_certificate.svg)](https://supermarket.chef.io/cookbooks/trusted_certificate)
[![CI State](https://github.com/sous-chefs/trusted_certificate/workflows/ci/badge.svg)](https://github.com/sous-chefs/trusted_certificate/actions?query=workflow%3Aci)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

This cookbook provides a `trusted_certificate` resource to manage adding SSL/TLS certificates to the operating system's trust store.

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you’d like to know more please visit sous-chefs.org or come chat with us on the Chef Community Slack in #sous-chefs.

## Requirements

### Platforms

- Debian/Ubuntu
- RHEL 6+

### Chef

- Chef 15.3+

### Cookbooks

- none

## Recipes

### default

Installs the `ca-certificates` package that provides the certificate trust mechanism.

## Resources

### trusted_certificate

Adds a certificate to the operating system's trust store.

#### properties

- `content`: The contents of the cert to add.  This can be specfied as inline content, a URL to a remote file, or a cookbook_file included in a wrapper cookbook.
- `certificate_name`: The filename of the cert

#### actions

- `create`
- `delete`

#### example

Create certificate from inline content:

```ruby
trusted_certificate 'my_corp' do
  action :create
  content 'THIS_WOULD_BE_THE_WHOLE_CERT_CONTENTS'
end
```

Download from a remote location:

```ruby
trusted_certificate 'my_corp_remote' do
  action :create
  content 'http://www.example.com/my_corp_remote.crt'
end
```

Create cert from file included in a wrapper cookbook:

```ruby
trusted_certificate 'my_corp_cert_wrapper' do
  action :create
  content 'cookbook_file://my_trusted_certs::my_corp_cert.crt'
end
```

Delete a certificate from the chain:

```ruby
trusted_certificate 'my_corp' do
  action :delete
end
```

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
