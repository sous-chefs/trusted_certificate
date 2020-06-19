# Install two certificates into the OS certificate store from a data_bag

custom_ca = data_bag_item('certs_to_install', 'custom_root_ca')

trusted_certificate 'Company Custom CA' do
  certificate_name 'custom_root_ca'
  content custom_ca['content']
  action :create
end

self_signed = data_bag_item('certs_to_install', 'self_signed_example')

trusted_certificate 'Web Server (self-signed)' do
  certificate_name 'self_signed_example'
  content self_signed['content']
  action :create
end
