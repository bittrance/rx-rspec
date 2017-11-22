require 'rspec'
require 'rx-rspec/shared'

RSpec::Matchers.define :emit_nothing do
  include RxRspec::Shared

  match do |actual|
    @actual = await_done do |done|
      actual.subscribe(
        lambda { |event| done.call(:events, event) },
        lambda { |err| done.call(:error, err) },
        lambda { done.call }
      )
    end
    return @actual.nil?
  end

  failure_message do
    type, emitted = @actual
    if type == :events
      "unexpected #{emitted} emitted"
    else
      present_error(expected, emitted)
    end
  end
end
