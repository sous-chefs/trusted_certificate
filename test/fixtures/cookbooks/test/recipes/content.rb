trusted_certificate 'remote_content' do
  content 'https://cacerts.digicert.com/DigiCertAssuredIDCA-1.crt'
  action :create
end

trusted_certificate 'cookbook_file_content' do
  content 'cookbook_file://test::testfile'
  action :create
end

trusted_certificate 'inline_content' do
  content "--------------BEGIN CERTIFICATE---------------------\nfobarbizabaz"
  action :create
end