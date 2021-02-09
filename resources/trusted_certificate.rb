#
# Cookbook:: trusted_certicate
# resource:: trusted_certicate
#
# Copyright:: Chef Software, Inc.
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

unified_mode true

resource_name :trusted_certificate
provides :trusted_certificate

property :certificate_name, String, name_property: true
property :content, String, required: [:create]
property :sensitive, [true, false], default: true

property :certificates_dir, String, default: lazy {
  case node['platform_family']
  when 'debian'
    '/usr/local/share/ca-certificates'
  when 'suse'
    '/etc/pki/trust/anchors/'
  else # probably RHEL
    '/etc/pki/ca-trust/source/anchors'
  end
}

def certificate_path
  "#{certificates_dir}/#{certificate_name}.crt"
end

action :create do
  execute 'update trusted certificates' do
    command update_cert_command
    action :nothing
  end

  if new_resource.content.start_with?('cookbook_file://')
    src = new_resource.content.split('://')[1].split('::')
    cookbook_file "#{certificate_path}/#{new_resource.certificate_name}.crt" do
      sensitive new_resource.sensitive
      source src[-1]
      cookbook src.length == 2 ? src[0] : cookbook_name
      owner 'root'
      group 'staff' if platform_family?('debian')
      notifies :run, 'execute[update trusted certificates]'
    end
  elsif new_resource.content =~ %r{^[a-zA-Z]*://.*}
    remote_file certificate_path do
      sensitive new_resource.sensitive if new_resource.sensitive
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

action_class do
  # @return [String] the platform specific command to update certs
  def update_cert_command
    platform_family?('debian', 'suse') ? 'update-ca-certificates' : 'update-ca-trust extract'
  end
end
