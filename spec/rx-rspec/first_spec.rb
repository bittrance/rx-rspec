require 'spec_helper'
require 'rx-rspec/first'

describe '#emit_first matcher' do
  context 'given empty observable' do
    subject { Rx::Observable.empty }
    it do
      expect { should emit_first }.to raise_error(/at least one/)
    end
    it do
      expect { should emit_first(42) }.to fail_with match(/at least \[42\]/)
    end
  end

  context 'given single-emitter observable' do
    subject { Rx::Observable.just(42) }
    it { should emit_first(42) }
    it do
      expect {
        should emit_first(43)
      }.to fail_with match(/at least \[43\]/)
    end
  end

  context 'given single-emitter async observable' do
    subject { Rx::Observable.just(42).delay(0) }
    it { should emit_first(42) }
    it do
      expect {
        should emit_first(43)
      }.to fail_with match(/at least \[43\]/)
    end
  end

  context 'given multi-emitter observable' do
    subject { Rx::Observable.of(1, 2, 3) }
    it { should emit_first(1, 2) }
    it { should emit_first(1, 2, 3) }
    it do
      expect {
        should emit_first(1, 2, 3, 4)
      }.to fail_with match(/at least \[1, 2, 3, 4\]/)
    end
  end

  context 'given erroring observable' do
    subject { Rx::Observable.raise_error(MyException.new('BOOM')) }
    it do
      expect {
        should emit_first(42)
      }.to fail_with match(/but received error.*MyException.*BOOM/)
    end
  end
end
