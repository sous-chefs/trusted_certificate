# frozen_string_literal: true

name 'trusted_certificate'

# The policy run_list points at the primary test cookbook recipe because this
# cookbook exposes resources only.
run_list 'test::default'

cookbook 'trusted_certificate', path: '.'
cookbook 'test', path: './test/cookbooks/test'
cookbook 'example', path: './spec/fixtures/cookbooks/example'

# Create named run list entries for each of recipes in testing cookbooks
tests = Dir.entries('./test/cookbooks/test/recipes').select { |f| !File.directory? f }
tests.each do |test|
  test = test.gsub('.rb', '')
  named_run_list :"#{test.to_sym}", "test::#{test}"
end

examples = Dir.entries('./spec/fixtures/cookbooks/example/recipes').select { |f| !File.directory? f }
examples.each do |example|
  example = example.gsub('.rb', '')
  named_run_list :"#{example.to_sym}", "example::#{example}"
end
