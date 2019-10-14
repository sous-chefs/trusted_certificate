#
# Cookbook:: trusted_certificate
# Spec:: content
#
# Copyright:: 2016 Chef Software Inc
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

require 'spec_helper'

describe 'test::content' do
  cached(:centos_7) do
    ChefSpec::ServerRunner.new(
      step_into: 'trusted_certificate',
      platform: 'centos',
      version: '7'
    ).converge(described_recipe)
  end

  context 'compiling the recipe' do
    it 'creates trusted_certificate[remote_content]' do
      expect(centos_7).to create_trusted_certificate('remote_content')
    end
    it 'creates trusted_certificate[cookbook_file_content]' do
      expect(centos_7).to create_trusted_certificate('cookbook_file_content')
    end
    it 'creates trusted_certificate[inline_content]' do
      expect(centos_7).to create_trusted_certificate('inline_content')
    end
  end

  context 'stepping into chef_file' do
    it 'correctly creates certificates from cookbook_files' do
      expect(centos_7).to create_cookbook_file('/etc/pki/ca-trust/source/anchors/cookbook_file_content.crt')
        .with(
          source: 'testfile',
          cookbook: 'test',
          user: 'root'
        )
    end
    it 'correctly creates certificates from remote_files' do
      expect(centos_7).to create_remote_file('/etc/pki/ca-trust/source/anchors/remote_content.crt')
        .with(
          source: 'https://www.example.com/test',
          user: 'root'
        )
    end
    it 'correctly creates certificates from inline content' do
      expect(centos_7).to create_file('/etc/pki/ca-trust/source/anchors/inline_content.crt')
        .with(
          content: "--------------BEGIN CERTIFICATE---------------------\nfobarbizabaz",
          user: 'root'
        )
      expect(centos_7).to render_file('/etc/pki/ca-trust/source/anchors/inline_content.crt').with_content("--------------BEGIN CERTIFICATE---------------------\nfobarbizabaz")
    end
  end
end
