require 'spec_helper'
require 'rx-rspec/complete'

describe '#complete matcher' do
  context 'given empty observable' do
    subject { Rx::Observable.empty }
    it { should complete }
  end

  context 'given single-emitter observable' do
    subject { Rx::Observable.just(42) }
    it { should complete }
  end

  context 'given single-emitter async observable' do
    subject { Rx::Observable.just(42).delay(0) }
    it { should complete }
  end

  context 'given erroring observable' do
    subject { Rx::Observable.raise_error(MyException.new('BOOM')) }
    it do
      expect {
        should complete
      }.to fail_with match(/but received error.*MyException.*BOOM/)
    end
  end

  context 'given a non-completing observable' do
    subject { Rx::Observable.create { |_| } }
    it do
      expect {
        should complete.within(0.2)
      }.to fail_with match(/timeout/i)
    end
  end
end
