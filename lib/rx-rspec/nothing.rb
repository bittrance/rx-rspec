require 'rspec'
require 'rx-rspec/shared'

# TODO:
# - should have specific timeout message 'x seconds waiting for y'

RSpec::Matchers.define :emit_nothing do |*expected|
  include RxRspec::Shared

  events = []
  errors = []
  completed = []
  match do |actual|
    Thread.new do
      actual.subscribe(
        lambda { |event| events << event },
        lambda { |err| errors << err },
        lambda { completed << :complete }
      )
      for n in 1..10
        break unless completed.empty?
        break unless errors.empty? && events.empty?
        sleep(0.05)
      end
      raise 'timeout' if errors.empty? && events.empty? && completed.empty?
    end.join

    return false unless errors.empty?
    return events.empty?
  end

  failure_message do
    if errors.empty?
      "unexpected #{events[0]} emitted"
    else
      present_error(expected, errors[0])
    end
  end
end
