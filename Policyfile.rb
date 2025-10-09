# Policyfile.rb - Describe how you want Chef Infra Client to build your system.
#
# For more information on the Policyfile feature, visit
# https://docs.chef.io/policyfile/

# A name that describes what the system you're building with Chef does.
name 'trusted_certificate'

# Where to find external cookbooks:
default_source :supermarket

# run_list: chef-client will run these recipes in the order specified.
run_list 'trusted_certificate'

# Specify a custom source for a single cookbook:
cookbook 'trusted_certificate', path: '.'
cookbook 'test', path: './test/fixtures/cookbooks/test'
cookbook 'example', path: './spec/fixtures/cookbooks/example'

# Create named run list entries for each of recipes in testing cookbooks
tests = Dir.entries('./test/fixtures/cookbooks/test/recipes').select { |f| !File.directory? f }
tests.each do |test|
  test = test.gsub('.rb', '')
  named_run_list :"#{test.to_sym}", "test::#{test}"
end

examples = Dir.entries('./spec/fixtures/cookbooks/example/recipes').select { |f| !File.directory? f }
examples.each do |example|
  example = example.gsub('.rb', '')
  named_run_list :"#{example.to_sym}", "example::#{example}"
end
