require 'simplecov'

SimpleCov.start do
  coverage_dir 'coverage'
  add_filter do |f|
    !%r{/lib/rx-rspec}.match(f.filename)
  end
end

require 'rspec/matchers/fail_matchers'
require 'rx'

RSpec.configure do |config|
  config.include RSpec::Matchers::FailMatchers
end

class MyException < Exception ; end
