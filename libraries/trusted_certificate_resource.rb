require 'chef/resource/lwrp_base'

class Chef
  class Resource
    class TrustedCertificate < Chef::Resource::LWRPBase
      provides :trusted_certificate

      actions :create
      default_action :create

      self.resource_name = :trusted_certificate

      attribute :certificate_name, kind_of: String,
                                   name_attribute: true,
                                   required: true
      attribute :content, kind_of: String, required: true
    end
  end
end
