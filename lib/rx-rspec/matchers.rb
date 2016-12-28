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

    expected.zip(events).all? do |exp, evt|
      if exp.respond_to?(:matches?)
        exp.matches?(evt)
      else
        exp == evt
      end
    end
  end

  description do
    if expected.size == 1
      "emit #{expected}"
    else
      "emit exactly #{expected.size} items"
    end
  end

  failure_message do
    if errors.empty?
      "expected #{events} to match #{expected}"
    else
      "expected #{expected} but received error #{errors[0].inspect}"
    end
  end

  diffable
end
