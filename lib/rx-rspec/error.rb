require 'rspec'
require 'rx-rspec/shared'

RSpec::Matchers.define :emit_error do
  include RxRspec::Shared

  match do |actual|
    error_class, message = expected
    begin
      @actual = await_done do |done|
        actual.subscribe(
          lambda { |event| done.call(:events, event) },
          lambda { |err| done.call(:error, err) },
          lambda { done.call(:complete, nil) }
        )
      end
    rescue Exception => err
      @actual = [:error, err]
      raise err
    end
    type, emitted = @actual
    return type == :error &&
      values_match?(error_class, emitted) &&
      values_match?(message, emitted.message)
  end

  failure_message do
    type, emitted = @actual
    if type == :events
      "unexpected #{emitted} emitted"
    elsif type == :complete
      "completed without error"
    else
      error_class, message = expected
      present_error("#{error_class} with #{message}", emitted)
    end
  end
end
