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

provides :trusted_certificate

action :create do
  execute 'update trusted certificates' do
    command platform_family?('debian', 'suse') ? 'update-ca-certificates' : 'update-ca-trust extract'
    action :nothing
  end

  file "#{certificate_path}/#{new_resource.certificate_name}.crt" do
    content new_resource.content
    owner 'root'
    group 'staff' if platform_family?('debian')
    action :create
    notifies :run, 'execute[update trusted certificates]'
  end
end

action :delete do
  execute 'update trusted certificates' do
    command platform_family?('debian', 'suse') ? 'update-ca-certificates' : 'update-ca-trust extract'
    action :nothing
  end

  file "#{certificate_path}/#{new_resource.certificate_name}.crt" do
    action :delete
    notifies :run, 'execute[update trusted certificates]'
  end
end

action_class do
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
