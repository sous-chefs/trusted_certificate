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
          execute 'update trusted certificates' do
            command platform_family?('debian') ? 'update-ca-certificates' : 'update-ca-trust extract'
            action :nothing
          end

          certificate_path =  platform_family?('debian') ? '/usr/local/share/ca-certificates' : '/etc/pki/ca-trust/source/anchors'
          if platform_family?('arch')
            certificate_path = '/etc/ca-certificates/trust-source/anchors/'
          end

          file "#{certificate_path}/#{new_resource.certificate_name}.crt" do
            content new_resource.content
            owner 'root'
            group 'staff' if platform_family?('debian')
            action :create
            notifies :run, 'execute[update trusted certificates]'
          end
        end
      end
    end
  end
end
