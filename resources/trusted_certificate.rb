# frozen_string_literal: true

provides :trusted_certificate
unified_mode true

property :certificate_name, String, name_property: true
property :certificates_dir, String, default: lazy { certificate_default_dir }
property :content, String, required: [:create]
property :install_ca_certificates, [true, false], default: true
property :sensitive, [true, false], default: true

# Allows reading the path from "outside" of the resource.
# See https://github.com/sous-chefs/trusted_certificate/issues/20
def certificate_path
  "#{certificates_dir}/#{certificate_name}.crt"
end

action :create do
  package ca_certificates_package do
    only_if { new_resource.install_ca_certificates }
  end

  execute 'update trusted certificates' do
    command update_cert_command
    action :nothing
  end

  if new_resource.content.start_with?('cookbook_file://')
    src = new_resource.content.split('://')[1].split('::')
    cookbook_file "#{certificate_path}/#{new_resource.certificate_name}.crt" do
      sensitive new_resource.sensitive
      source src.last
      cookbook src.length == 2 ? src.first : cookbook_name
      owner 'root'
      group 'staff' if platform_family?('debian')
      notifies :run, 'execute[update trusted certificates]'
    end
  elsif new_resource.content =~ %r{^[a-zA-Z]*://.*}
    remote_file certificate_path do
      sensitive new_resource.sensitive
      source new_resource.content
      owner 'root'
      group 'staff' if platform_family?('debian')
      notifies :run, 'execute[update trusted certificates]'
    end
  else
    file certificate_path do
      content new_resource.content
      owner 'root'
      group 'staff' if platform_family?('debian')
      action :create
      notifies :run, 'execute[update trusted certificates]'
    end
  end
end

action :delete do
  execute 'update trusted certificates' do
    command update_cert_command
    action :nothing
  end

  file certificate_path do
    action :delete
    notifies :run, 'execute[update trusted certificates]'
  end
end

action :remove do
  execute 'update trusted certificates' do
    command update_cert_command
    action :nothing
  end

  file "#{certificate_path}/#{new_resource.certificate_name}.crt" do
    action :delete
    notifies :run, 'execute[update trusted certificates]'
  end
end

action_class do
  def ca_certificates_package
    'ca-certificates'
  end

  # @return [String] the platform specific command to update certs
  def update_cert_command
    platform_family?('debian', 'suse') ? 'update-ca-certificates' : 'update-ca-trust extract'
  end

  # @return [String] the platform specific path to certs
  def certificate_default_dir
    case node['platform_family']
    when 'debian'
      '/usr/local/share/ca-certificates'
    when 'suse'
      '/etc/pki/trust/anchors/'
    else # probably RHEL
      '/etc/pki/ca-trust/source/anchors'
    end
  end
end
