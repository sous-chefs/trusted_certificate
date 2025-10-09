certificate_path =
  case os.family
  when 'debian'
    '/usr/local/share/ca-certificates'
  when 'suse'
    '/etc/pki/trust/anchors/'
  else # probably RHEL
    '/etc/pki/ca-trust/source/anchors'
  end

describe file("#{certificate_path}/custom_root_ca.crt") do
  it { should exist }
  its('content') { should cmp "-----BEGIN CERTIFICATE-----\nMIID3TCCAsWgAwIBAgIJAIw2QXrtH3hsMA0GCSqGSIb3DQEBCwUAME0xCzAJBgNV\nBAYTAlVTMRYwFAYDVQQKDA1DaGVmIFNvZnR3YXJlMRQwEgYDVQQLDAtFbmdpbmVl\ncmluZzEQMA4GA1UEAwwHUm9vdCBDQTAeFw0xNTA3MjIxNTAyNDFaFw0zNTA3MTcx\nNTAyNDFaME0xCzAJBgNVBAYTAlVTMRYwFAYDVQQKDA1DaGVmIFNvZnR3YXJlMRQw\nEgYDVQQLDAtFbmdpbmVlcmluZzEQMA4GA1UEAwwHUm9vdCBDQTCCASIwDQYJKoZI\nhvcNAQEBBQADggEPADCCAQoCggEBAOhmT+xUrGil3j50ABnBV74AoeRM9S00GShp\nO8c7Yyo/8MaSZxCg+12XMbZfLxHGpmmOFpkSalkBbEabJYHc10pft93qOxU9qj5v\nFBEs4nrbltZVh47VrhdVrm7GvY8UhNOc9uuG2PPisTZN//pc7vC2xM1g1CEW9A18\n30ttGLPWP+7jfR6MLbxTZkkGlC2N/Ua5nyzeRbIbJVdZ+miQqFtd8Qj2cp1i8zz1\nme31GR+Q3HV887KOC9Yy2+ztiEnX7K6nQ3Rf6Y9JQZgNIcsJYJbAy+ov9UPJet7U\n7twd0GltDscWwTWt1ypICxCpS1HSjNiMTVDJlL+AAFFpTGgW9W8CAwEAAaOBvzCB\nvDAdBgNVHQ4EFgQU89wLqIEL65rjzJggWL/Y/V8JbbUwfQYDVR0jBHYwdIAU89wL\nqIEL65rjzJggWL/Y/V8JbbWhUaRPME0xCzAJBgNVBAYTAlVTMRYwFAYDVQQKDA1D\naGVmIFNvZnR3YXJlMRQwEgYDVQQLDAtFbmdpbmVlcmluZzEQMA4GA1UEAwwHUm9v\ndCBDQYIJAIw2QXrtH3hsMA8GA1UdEwEB/wQFMAMBAf8wCwYDVR0PBAQDAgEGMA0G\nCSqGSIb3DQEBCwUAA4IBAQACXSnELJRgpvJC/cOesLkMvB4L3UzBPXMFPEUICzRB\nCqPln7j4R+mqfu+ErFq7Be4f9ETG1aBrSa74ZdUdOmG6NGdKoyh8VLqQ4zRIDvCF\nBFtQ2FwhiYPLH68E5sdLFa1MAfjHVyYXmvkhft/KWy4Xm9Ad/QwMGbLGhrwHmMKC\n14dRTtwNx1ZWXqXo+4dhCvlIeJzBbfCLkVkp665Lbar/2UB+U9F+uMBavEVIJy2V\ndxCrY8dzYgB1mh9nUWFcmG2NXDa42OvwdttF1pmo02k3sfnkHXmdgOK1iC3DBgs1\nu6uHQqXCKofb95d3RDK1B7oBzCvu0SbXwrGGB+2vF0nq\n-----END CERTIFICATE-----" }
end

describe file("#{certificate_path}/self_signed_example.crt") do
  it { should_not exist }
end
