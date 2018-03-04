require 'rspec'
require 'rx-rspec/shared'

RSpec::Matchers.define :complete do
  include RxRspec::Shared

  match do |actual|
    begin
      @actual = await_done do |done|
        actual.subscribe(
          lambda { |_| },
          lambda { |err| done.call(:error, err) },
          lambda { done.call }
        )
      end
    rescue Exception => err
      @actual = [:error, err]
      raise err
    end
    @actual.nil?
  end

  failure_message do
    _, emitted = @actual
    present_error(expected, emitted)
  end
end
