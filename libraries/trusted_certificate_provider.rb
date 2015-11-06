require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class TrustedCertificate < Chef::Provider::LWRPBase
      provides :trusted_certificate
      use_inline_resources

      def whyrun_supported?
        true
      end

      action :create do
        converge_by "Add #{new_resource.name} to OS trust store" do
          execute 'update-ca-certificates' do
            action :nothing
          end

          certificate_path = '/usr/local/share/ca-certificates/' \
                             "#{new_resource.certificate_name}.crt"

          file certificate_path do
            content new_resource.content
            owner 'root'
            group 'staff'
            action :create
            notifies :run, 'execute[update-ca-certificates]'
          end
        end
      end
    end
  end
end
