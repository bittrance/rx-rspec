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
      done_args = nil
      error = nil
      done = Proc.new do |*args|
        done_args = args
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
      while Time.now < deadline && done_args.nil?
        gate.synchronize { condition.wait(gate, deadline - Time.now) }
      end

      if error
        raise error
      elsif done_args.nil?
        RSpec::Expectations.fail_with("Timeout after #{@timeout}")
      end
      
      if done_args.nil? || done_args.size == 0
        nil
      else
        done_args
      end
    end
  end
end
