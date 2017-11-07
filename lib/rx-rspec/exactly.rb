require 'rspec'
require 'rx-rspec/shared'

# TODO:
# - should have specific timeout message 'x seconds waiting for y'

RSpec::Matchers.define :emit_exactly do |*expected|
  include RxRspec::Shared

  events = []
  errors = []
  match do |actual|
    Thread.new do
      spinlock = expected.size
      actual.subscribe(
        lambda do |event|
          events << event
          spinlock -= 1
        end,
        lambda do |err|
          errors << err
          spinlock = 0
        end,
        lambda { spinlock = 0 }
      )
      for n in 1..10
        break if spinlock == 0
        sleep(0.05)
      end
      raise 'timeout' if spinlock > 0
    end.join

    return false unless errors.empty?
    @actual = events
    values_match? expected, events
  end

  diffable

  failure_message do
    if errors.empty?
      "expected #{events} to match #{expected}"
    else
      present_error(expected, errors[0])
    end
  end
end
