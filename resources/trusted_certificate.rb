#
# Cookbook:: trusted_certicate
# resource:: trusted_certicate
#
# Copyright:: 2015-2017, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

property :certificate_name, String, name_property: true
property :content, String, required: true
property :cookbook, String, default: lazy { cookbook_name }

provides :trusted_certificate

action :create do
  execute 'update trusted certificates' do
    command update_cert_command
    action :nothing
  end

  resource_type = fetching_resource(new_resource.content)

  declare_resource(resource_type, "#{certificate_path}/#{new_resource.certificate_name}.crt") do
    content new_resource.content if resource_type == :file # source directly from content property
    source source_uri if resource_type == :remote_file # source from a URI
    source new_resource.content if resource_type == :cookbook_file # content is a filename in a cookbook
    cookbook new_resource.cookbook if resource_type == :cookbook_file
    owner 'root'
    group 'staff' if platform_family?('debian')
    action :create
    notifies :run, 'execute[update trusted certificates]'
  end
end

action :delete do
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
  def source_uri
    new_resource.content.start_with?('/') ? "file://#{new_resource.content}" : new_resource.content
  end

  # determine if a cookbook file is available in the run
  # @param [String] fn the path to the cookbook file
  #
  # @return [Boolean] cookbook file exists or doesn't
  def has_cookbook_file?(fn) # rubocop: disable Naming/PredicateName
    run_context.has_cookbook_file_in_cookbook?(new_resource.cookbook, fn)
  end

  # Given the provided cert URI determine what kind of chef resource we need to fetch the cert
  # @param [String] uri the uri of the cert (local path, http URL, or the actual cert)
  #
  # @raise [Chef::Exceptions::FileNotFound] Cert isn't valid, local, remote or found in the current run
  #
  # @return [Symbol] :remote_file or :cookbook_file
  def fetching_resource(uri)
    if /.*-----BEGIN CERTIFICATE-----.*/.match?(uri)
      :file
    elsif %r{^[a-zA-Z]*://.*}.match?(uri)
      Chef::Log.debug('#cert_type: The content looks like a URI. Using remote_file to fetch.')
      :remote_file
    elsif uri.start_with?('/') && ::File.exist?(uri)
      Chef::Log.debug('#cert_type: The content looks like a local file. Using remote_file to copy.')
      :remote_file
    elsif has_cookbook_file?(uri) # file in a cookbook
      Chef::Log.debug('#cert_type: The content looks like the name of a cookbook file. Using cookbook_file to fetch.')
      :cookbook_file
    else
      raise Chef::Exceptions::FileNotFound, 'Content does not appear to be a certificate, a URI, a local path, or a cookbook file. Cannot continue!'
    end
  end

  # @return [String] the platform specific command to update certs
  def update_cert_command
    platform_family?('debian', 'suse') ? 'update-ca-certificates' : 'update-ca-trust extract'
  end

  # @return [String] the platform specific path to certs
  def certificate_path
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
