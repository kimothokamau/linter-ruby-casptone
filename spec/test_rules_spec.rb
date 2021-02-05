require_relative '../lib/check_rules'
require_relative '../lib/css_linter_logic'

describe Validate do
  describe '#start' do
    subject(:validate_start) { described_class.new }
    let(:file) { instance_double(File) }

    it 'sends each_line' do
      expect(file).to receive(:each_line)
      validate_start.start(file)
    end

    context 'if the file has one line' do
      it 'calls validate_line once' do
        expect(validate_start).to receive(:validate_line).once
        file = StringIO.new('1')
        validate_start.start(file)
      end
    end

    context 'if the file has more than one lines' do
      it 'calls validate_line 4 times' do
        expect(validate_start).to receive(:validate_line).exactly(4).times
        file = StringIO.new("1\n2\n3\n4")
        validate_start.start(file)
      end
    end
  end

  describe '#create_buffer' do
    subject(:validate_buffer) { described_class.new }

    it 'creates a new StringScanner with a line of string' do
      expect(StringScanner).to receive(:new).with('this is a string line')
      line = 'this is a string line'
      validate_buffer.send(:create_buffer, line)
    end
  end
end
