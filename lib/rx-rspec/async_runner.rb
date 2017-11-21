require 'rspec'

module RxRspec
  class TimeoutError < RuntimeError ; end

  class AsyncRunner
    def initialize(timeout)
      @timeout = timeout
    end

    def await_done(&block)
      condition = ConditionVariable.new
      deadline = Time.now + @timeout
      done_called = false
      error = nil
      done = Proc.new do
        done_called = true
        condition.signal
      end
      Thread.new do
        begin
          block.call(done)
        rescue => e
          error = e
          done.call
        end
      end.join(@timeout)

      gate = Mutex.new
      until Time.now >= deadline || done_called
        gate.synchronize { condition.wait(gate, deadline - Time.now) }
      end

      if error
        raise error
      elsif !done_called
        RSpec::Expectations.fail_with("Timeout after #{@timeout}")
      end
    end
  end
end
