require 'spec_helper'
require 'rx-rspec/nothing'

describe '#emit_nothing matcher' do
  context 'given empty observable' do
    subject { Rx::Observable.empty }
    it { should emit_nothing }
    it { should emit_nothing.within(0.1) }
  end

  context 'given single-emitter observable' do
    subject { Rx::Observable.just(42) }
    it do
      expect {
        should emit_nothing
      }.to fail_with match(/unexpected.* 42/)
    end
  end

  context 'given erroring observable' do
    subject { Rx::Observable.raise_error(MyException.new('BOOM')) }
    it do
      expect {
        should emit_nothing
      }.to fail_with match(/but received error.*MyException.*BOOM/)
    end
  end

  context 'given a non-completing observable' do
    subject { Rx::Observable.create { |_| } }
    it do
      expect {
        should emit_nothing.within(0.2)
      }.to fail_with match(/timeout/i)
    end
  end
end
