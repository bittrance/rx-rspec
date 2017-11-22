require 'rspec'
require 'rx-rspec/shared'

RSpec::Matchers.define :emit_include do |*expected|
  include RxRspec::Shared

  match do |actual|
    expected = expected.dup
    events = []
    error = await_done do |done|
      actual.take_while do |event|
        events << event
        idx = expected.index { |exp| values_match?(exp, event) }
        expected.delete_at(idx) unless idx.nil?
        expected.size > 0
      end.subscribe(
        lambda { |event| },
        lambda { |err| done.call(:error, err) },
        lambda { done.call }
      )
    end

    @actual = error || [:events, events]
    expected.empty? && error.nil?
  end

  failure_message do
    type, emitted = @actual
    if type == :events
      "expected #{emitted} to include #{expected}"
    else
      present_error(expected, emitted)
    end
  end
end
