RSpec::Matchers.define :emit_include do |*expected|
  events = []
  errors = []
  completed = []

  match do |actual|
    expected = expected.dup
    Thread.new do
      deadline = Time.now + 0.5
      actual.subscribe_on_error { |err| errors << err }
      subscription = actual.delay(0).subscribe(
        lambda do |event|
          events << event
          idx = expected.index { |exp| values_match?(exp, event) }
          expected.delete_at(idx) unless idx.nil?
          subscription.unsubscribe if expected.empty?
        end,
        lambda {}, # Seems we cannot get here
        lambda { completed << :complete }
      )

      until Time.now > deadline
        break if expected.empty?
        break unless completed.empty? && errors.empty?
        sleep(0.05)
      end
      raise 'timeout' if Time.now > deadline
    end.join

    expected.empty?
  end

  failure_message do
    if errors.empty?
      "expected #{events} to include #{expected}"
    else
      "expected #{expected} but received error #{errors[0].inspect}"
    end
  end
end

RSpec::Matchers.define :emit_exactly do |*expected|
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
    values_match? expected, events
  end

  failure_message do
    if errors.empty?
      "expected #{events} to match #{expected}"
    else
      "expected #{expected} but received error #{errors[0].inspect}"
    end
  end
end
