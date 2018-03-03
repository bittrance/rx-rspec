require 'spec_helper'
require 'rx-rspec/error'

describe '#emit_error matcher' do
  context 'given empty observable' do
    subject { Rx::Observable.empty }
    it do
      expect do
        should emit_error(MyException, /BOOM/)
      end.to fail_with(/completed without error/)
    end
  end

  context 'given single-emitter observable' do
    subject { Rx::Observable.just(42) }
    it do
      expect do
        should emit_error(MyException, /BOOM/)
      end.to fail_with(/unexpected 42 emitted/)
    end
  end

  context 'given erroring observable with the expected exception' do
    subject { Rx::Observable.raise_error(MyException.new('BOOM')) }
    it { should emit_error(MyException, /BOOM/) }
  end

  context 'given erroring observable with an unexpected exception' do
    subject { Rx::Observable.raise_error(RuntimeError.new('BOOM')) }
    it do
      expect do
        should emit_error(MyException, /BOOM/)
      end.to fail_with match(/but received.*RuntimeError.*BOOM/)
    end
  end

  context 'given erroring observable with an unexpected message' do
    subject { Rx::Observable.raise_error(MyException.new('BAM!')) }
    it do
      expect do
        should emit_error(MyException, /BOOM/)
      end.to fail_with match(/but received.*MyException.*BAM/)
    end
  end

  context 'given a non-completing observable' do
    subject { Rx::Observable.create { |_| } }
    it do
      expect do
        should emit_error(MyException, /BOOM/).within(0.2)
      end.to fail_with match(/timeout/i)
    end
  end
end
