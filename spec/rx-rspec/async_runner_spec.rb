require 'time'

require 'rx-rspec/async_runner'

describe RxRspec::AsyncRunner do
  describe '#await_done' do
    let(:timeout) { 0.2 }
    let(:runner) { described_class.new(timeout) }

    it 'supports announcing that the block is done' do
      start = Time.now
      runner.await_done do |done|
        done.call
      end
      expect(Time.now - start).to be < 0.1
    end

    it 'passes arguments to done on to caller' do
      expect(runner.await_done {|done| done.call(1, 2) }).to eq([1, 2])
    end

    it 'passes nil to caller when done gets no arguments' do
      expect(runner.await_done {|done| done.call }).to eq(nil)
    end

    it 'raises timeout failure after timeout' do
      start = Time.now
      expect do
        runner.await_done {|_| }
      end.to fail_with(/timeout/i)
      expect(Time.now - start).to be >= 0.2
    end

    it 'propagates exceptions from within the block' do
      start = Time.now
      expect do
        runner.await_done do |_|
          raise 'badness'
        end
      end.to raise_error(/badness/)
      expect(Time.now - start).to be < 0.1
    end
  end
end
