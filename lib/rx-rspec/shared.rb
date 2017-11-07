module RxRspec
  module Shared
    def present_error(expected, error)
      backtrace = error.backtrace || []
      present_error = "#{error.inspect}:#{$/}#{backtrace.join($/)}"
      "expected #{expected} but received error #{present_error}"
    end
  end
end
