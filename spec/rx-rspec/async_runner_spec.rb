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

    it 'raises timeout failure after timeout' do
      start = Time.now
      expect do
        runner.await_done {|_| }
      end.to fail_with(/timeout/i)
      expect(Time.now - start).to be >= 0.2
      expect(Time.now - start).to be < 0.3
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