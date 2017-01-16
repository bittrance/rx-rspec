require 'spec_helper'
require 'rx-rspec/include'

describe '#emit_include' do
  context 'given empty observable' do
    subject { Rx::Observable.empty }
    it do
      expect {
        should emit_include(42)
      }.to fail_with match(/to include \[42\]/)
    end
  end

  context 'given single-emitter observable' do
    subject { Rx::Observable.just(42) }
    it { should emit_include(42) }
  end

  context 'given single-emitter observable' do
    subject { Rx::Observable.just('42') }
    it { should emit_include(match(/42/)) }
  end

  context 'given multi-emitter observable' do
    subject { Rx::Observable.of(1, 2, 3, 1, 4, 5) }
    it { should emit_include(3, 2) }
    it do
      expect {
        should emit_include(3, 6)
      }.to fail_with match(/to include \[6\]/)
    end
    it { should emit_include(1, 1) }
    it do
      expect {
        should emit_include(1, 1, 1)
      }.to fail_with match(/to include \[1\]/)
    end
  end

  context 'given concatenated observables' do
    let(:second_observable) { double(:second_observable, :called => nil) }
    subject do
      Rx::Observable.concat(
        Rx::Observable.create { |o| o.on_next(1) ; o.on_completed },
        Rx::Observable.create { |o| second_observable.called ; o.on_completed }
      )
    end

    it 'does not consume more than necessary' do
      should emit_include(1)
      expect(second_observable).not_to have_received(:called)
    end
  end

  context 'given erroring observable' do
    class MyException < Exception ; end
    subject { Rx::Observable.raise_error(MyException.new('BOOM')) }
    it do
      expect {
        should emit_include(42)
      }.to fail_with match(/but received error.*MyException.*BOOM/)
    end
  end
end
