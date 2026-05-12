# trusted_certificate migration guide

This release completes the cookbook's migration to a custom-resource-only API.

## What changed

The `trusted_certificate::default` recipe has been removed. Use the `trusted_certificate` resource directly from a wrapper cookbook or role-specific test cookbook recipe.

There were no cookbook attributes to migrate. Configuration now belongs on resource properties such as `certificate_name`, `content`, `install_ca_certificates`, and `sensitive`.

## Before

```ruby
include_recipe 'trusted_certificate::default'

trusted_certificate 'my_corp' do
  content 'THIS_WOULD_BE_THE_WHOLE_CERT_CONTENTS'
end
```

## After

```ruby
trusted_certificate 'my_corp' do
  content 'THIS_WOULD_BE_THE_WHOLE_CERT_CONTENTS'
end
```

The resource installs the `ca-certificates` package by default. If another cookbook manages that package, disable package installation:

```ruby
trusted_certificate 'my_corp' do
  content 'THIS_WOULD_BE_THE_WHOLE_CERT_CONTENTS'
  install_ca_certificates false
end
```

## Test cookbook examples

Usage examples now live under `test/cookbooks/test/recipes/`:

* `test/cookbooks/test/recipes/default.rb` covers inline create and remove behavior.
* `test/cookbooks/test/recipes/content.rb` covers remote, cookbook file, and inline content sources.
