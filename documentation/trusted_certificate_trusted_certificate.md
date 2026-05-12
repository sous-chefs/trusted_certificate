# trusted_certificate_trusted_certificate

Use the `trusted_certificate` resource to install or remove a certificate from the operating system trust store.

## Actions

* `:create` installs the `ca-certificates` package by default, writes the certificate, and updates the trust store.
* `:delete` removes the certificate file and updates the trust store.
* `:remove` is an alias-style removal action with the same behavior as `:delete`.

## Properties

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `certificate_name` | String | resource name | Certificate filename without the `.crt` extension. |
| `content` | String | required for `:create` | Inline certificate content, a remote URL, or `cookbook_file://cookbook::path`. |
| `install_ca_certificates` | true, false | `true` | Install the platform `ca-certificates` package before writing certificates. |
| `sensitive` | true, false | `true` | Marks managed file resources as sensitive. |

## Examples

```ruby
trusted_certificate 'my_corp' do
  content 'THIS_WOULD_BE_THE_WHOLE_CERT_CONTENTS'
end
```

```ruby
trusted_certificate 'my_corp_remote' do
  content 'https://www.example.com/my_corp_remote.crt'
end
```

```ruby
trusted_certificate 'my_corp_cert_wrapper' do
  content 'cookbook_file://my_trusted_certs::my_corp_cert.crt'
end
```

```ruby
trusted_certificate 'my_corp' do
  action :remove
end
```
