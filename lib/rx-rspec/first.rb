require 'rspec'

# TODO:
# - should have specific timeout message 'x seconds waiting for y'

RSpec::Matchers.define :emit_first do |*expected|
  events = []
  errors = []
  completed = []

  match do |actual|
    raise 'Please supply at least one expectation' if expected.size == 0
    expect_clone = expected.dup
    Thread.new do
      deadline = Time.now + 0.5
      actual.take_while do |event|
        events << event
        values_match?(expect_clone.shift, event) && expect_clone.size > 0
      end.subscribe(
        lambda { |event| },
        lambda { |err| errors << err },
        lambda { completed << :complete }
      )

      until Time.now > deadline
        break if expect_clone.empty?
        break unless completed.empty? && errors.empty?
        sleep(0.05)
      end
      raise 'timeout' if Time.now > deadline
    end.join

    expect_clone.empty?
  end

  failure_message do
    if errors.empty?
      "expected #{events} to emit at least #{expected}"
    else
      "expected #{expected} but received error #{errors[0].inspect}"
    end
  end
end
