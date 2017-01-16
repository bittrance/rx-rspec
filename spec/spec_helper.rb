require 'simplecov'

SimpleCov.start

require 'rspec/matchers/fail_matchers'
require 'rx'

RSpec.configure do |config|
  config.include RSpec::Matchers::FailMatchers
end

class MyException < Exception ; end