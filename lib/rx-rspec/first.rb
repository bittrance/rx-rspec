require 'rspec'
require 'rx-rspec/shared'

RSpec::Matchers.define :emit_first do |*expected|
  include RxRspec::Shared

  match do |actual|
    raise 'Please supply at least one expectation' if expected.size == 0
    expect_clone = expected.dup
    events = []
    error = await_done do |done|
      actual.take_while do |event|
        events << event
        values_match?(expect_clone.shift, event) && expect_clone.size > 0
      end.subscribe(
        lambda { |event| },
        lambda { |err| done.call(:error, err) },
        lambda { done.call }
      )
    end

    @actual = error || [:events, events]
    error.nil? && values_match?(expected, events)
  end

  failure_message do
    type, emitted = @actual
    if type == :events
      "expected #{emitted} to emit at least #{expected}"
    else
      present_error(expected, emitted)
    end
  end
end
