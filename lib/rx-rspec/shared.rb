module RxRspec
  module Shared
    DEFAULT_TIMEOUT = 0.5

    def timeout
      @timeout || DEFAULT_TIMEOUT
    end

    # chain :within do |seconds|
    #  @timeout = seconds
    # end
    
    def await_done(&block)
      AsyncRunner.new(@timeout).await_done(&block)
    end

    def present_error(expected, error)
      backtrace = error.backtrace || []
      present_error = "#{error.inspect}:#{$/}#{backtrace.join($/)}"
      "expected #{expected} but received error #{present_error}"
    end
  end
end
