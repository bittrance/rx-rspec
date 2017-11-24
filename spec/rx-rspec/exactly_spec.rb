require 'spec_helper'
require 'rx-rspec/exactly'

describe '#emit_exactly matcher' do
  context 'given empty observable' do
    subject { Rx::Observable.empty }
    it { should emit_exactly }
  end

  context 'given single-emitter observable' do
    subject { Rx::Observable.just(42) }
    it { should emit_exactly(42) }
  end

  context 'given single-emitter async observable' do
    subject { Rx::Observable.just(42).delay(0) }
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
    it do
      expect {
        should emit_exactly(1, 2)
      }.to fail_with match(/to match \[1, 2\]/)
    end
  end

  context 'given an observable that emits a non-matching hashes' do
    subject { Rx::Observable.just({v: 'k'}) }
    it do
      expect {
        should emit_exactly({k: 'v'})
      }.to fail_with match(/-.*:k.*\+.*:v/m)
    end
  end

  context 'given erroring observable' do
    let :exception do
      MyException.new('BOOM').tap {|e| e.set_backtrace(['ze-traceback']) }
    end
    subject { Rx::Observable.raise_error(exception) }
    it do
      expect {
        should emit_exactly
      }.to fail_with match(/but received error.*MyException.*BOOM.*ze-traceback/m)
    end
  end

  context 'given a non-completing observable' do
    subject { Rx::Observable.create { |_| } }
    it do
      expect {
        should emit_exactly(1, 2).within(0.2)
      }.to fail_with match(/timeout/i)
    end
  end
end
