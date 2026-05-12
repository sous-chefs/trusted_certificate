# trusted_certificate limitations

This cookbook manages operating system trust stores with Chef built-in resources and the platform certificate update tools.

## Platform and architecture support

The resource is architecture independent. It writes certificate files and runs the platform trust-store update command, so support is constrained by the operating system family and the availability of the `ca-certificates` package and update command.

| Platform family | Tested/current versions | Package source | Update command |
| --- | --- | --- | --- |
| AlmaLinux | 8, 9 | dnf/yum | `update-ca-trust extract` |
| Amazon Linux | 2023 | dnf/yum | `update-ca-trust extract` |
| CentOS Stream | 9 | dnf/yum | `update-ca-trust extract` |
| Debian | 12 | apt | `update-ca-certificates` |
| Fedora | latest | dnf | `update-ca-trust extract` |
| Oracle Linux | 8, 9 | dnf/yum | `update-ca-trust extract` |
| Rocky Linux | 8, 9 | dnf/yum | `update-ca-trust extract` |
| Ubuntu | 22.04, 24.04 | apt | `update-ca-certificates` |

## Unsupported legacy platforms

CentOS 7 and 8, Debian 9, Debian 10, Debian 11, Ubuntu 18.04, Ubuntu 20.04, Amazon Linux 2, and openSUSE Leap 15.x are no longer in the active Kitchen and CI matrix because they are end-of-life or no longer a current target for this migration.

## Source install constraints

No compiled or source installation path is required. The cookbook installs the platform `ca-certificates` package by default and can skip that package with the `install_ca_certificates false` property when a wrapper cookbook manages the package separately.
