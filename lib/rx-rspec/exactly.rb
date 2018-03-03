require 'rspec'
require 'rx-rspec/shared'

RSpec::Matchers.define :emit_exactly do |*expected|
  include RxRspec::Shared

  match do |actual|
    events = []
    begin
      error = await_done do |done|
        actual.subscribe(
          lambda do |event|
            events << event
            done.call if events.size > expected.size
          end,
          lambda { |err| done.call(:error, err) },
          lambda { done.call }
        )
      end
    rescue Exception => err
      @actual = [:error, err]
      raise err
    end

    @actual = error || [:events, events]
    error.nil? && values_match?(expected, events)
  end

  diffable

  failure_message do
    type, emitted = @actual
    if type == :events
      "expected #{emitted} to match #{expected}"
    else
      present_error(expected, emitted)
    end
  end
end
