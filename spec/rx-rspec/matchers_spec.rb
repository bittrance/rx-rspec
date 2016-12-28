require 'rspec/matchers/fail_matchers'
require 'rx'
require 'rx-rspec/matchers'

RSpec.configure do |config|
  config.include RSpec::Matchers::FailMatchers
end

describe '#emit_exactly matcher' do
  context 'given empty observable' do
    subject { Rx::Observable.empty }
    it { should emit_exactly }
  end

  context 'given single-emitter observable' do
    subject { Rx::Observable.just(42) }
    it { should emit_exactly(42) }
  end

  context 'given multi-emitter observable' do
    subject { Rx::Observable.of(1, 2, 3) }
    it { should emit_exactly(1, 2, 3) }
    it do
      expect {
        should emit_exactly(1, 2, 3, 4)
      }.to fail_with match(/to match \[1, 2, 3, 4\]/)
    end
  end

  context 'given erroring observable' do
    class MyException < Exception ; end
    subject { Rx::Observable.raise_error(MyException.new('BOOM')) }
    it do
      expect {
        should emit_exactly
      }.to fail_with match(/but received error.*MyException.*BOOM/)
    end
  end
end
