require 'rspec'
require 'rx-rspec/async_runner'

module RxRspec
  module Shared
    DEFAULT_TIMEOUT = 0.5

    def self.included(mod)
      mod.chain :within do |seconds|
        @timeout = seconds
      end

      mod.description do
        if @timeout
          super() + " within #{@timeout} seconds"
        else
          super()
        end
      end
    end

    def timeout
      @timeout || DEFAULT_TIMEOUT
    end

    def await_done(&block)
      AsyncRunner.new(timeout).await_done(&block)
    end

    def present_error(expected, error)
      backtrace = error.backtrace || []
      return error.message if /^Timeout/.match(error.message)
      present_error = "#{error.inspect}:#{$/}#{backtrace.join($/)}"
      "expected #{expected} but received error #{present_error}"
    end
  end
end
