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

  describe '#validate_line' do
    subject(:line_count) { described_class.new }
    let(:buffer) { instance_double(StringScanner) }

    before do
      allow(line_count).to receive(:check_match).and_return(false)
    end

    it 'adss 1 to @line_number' do
      call_checkline = proc { line_count.send(:validate_line, buffer) }
      line_number = proc { line_count.instance_variable_get(:@line_number) }
      expect(&call_checkline).to change(&line_number).by(1)
    end

    context 'When an error is detected in a line by all 3 checkers' do
      subject(:validates_line) { described_class.new }

      before do
        allow(validates_line).to receive(:check_match).and_return(true, true, true)
        allow($stdout).to receive(:puts)
        allow(buffer).to receive(:scan_until)
        allow(validates_line).to receive(:display_error)
        allow(buffer).to receive(:reset)
      end

      it 'changes @line_errors to true' do
        validates_line.send(:validate_line, buffer)
        line_errors = validates_line.line_errors
        expect(line_errors).to be_truthy
      end
    end

    context 'When an error is detected in a line by two checkers' do
      subject(:validates_line) { described_class.new }

      before do
        allow(validates_line).to receive(:check_match).and_return(false, true, true)
        allow($stdout).to receive(:puts)
        allow(buffer).to receive(:scan_until)
        allow(validates_line).to receive(:display_error)
        allow(buffer).to receive(:reset)
      end

      it 'changes @line_errors to true' do
        validates_line.send(:validate_line, buffer)
        line_errors = validates_line.line_errors
        expect(line_errors).to be_truthy
      end
    end

    context 'when an error is detected in a line by one checker' do
      subject(:validates_line) { described_class.new }

      before do
        allow(validates_line).to receive(:check_match).and_return(false, false, true)
        allow($stdout).to receive(:puts)
        allow(buffer).to receive(:scan_until)
        allow(validates_line).to receive(:display_error)
        allow(buffer).to receive(:reset)
      end

      it 'changes @line_errors to true' do
        validates_line.send(:validate_line, buffer)
        line_errors = validates_line.line_errors
        expect(line_errors).to be_truthy
      end
    end
  end

  describe '#check_match' do
    subject(:validate_pattern) { described_class.new }

    context 'when errors are detected in the scanned code' do
      let(:buffer) { StringScanner.new('. ticket-wrapper {') }

      context 'When a whitespace is detected after the dot(class) selector: /\. [a-zA-Z0-9-]/' do
        it 'returns a truthy value' do
          pattern = /\. [a-zA-Z0-9-]/
          result = validate_pattern.send(:check_match, buffer, pattern)
          expect(result).to be_truthy
        end
      end

      context 'when a whitespace is detected after the # selector: /\# [a-zA-Z0-9-]/' do
        let(:buffer) { StringScanner.new('# lunch-wrapper {') }
        it 'returns a truthy value' do
          pattern = /\# [a-zA-Z0-9-]/
          result = validate_pattern.send(:check_match, buffer, pattern)
          expect(result).to be_truthy
        end
      end

      context 'when there is no space after the selector name and opening curly brace: /\.[a-zA-Z0-9-]+\{/' do
        let(:buffer) { StringScanner.new('.ticket-wrapper{') }
        it 'returns a truthy value' do
          pattern = /\.[a-zA-Z0-9-]+\{/
          result = validate_pattern.send(:check_match, buffer, pattern)
          expect(result).to be_truthy
        end
      end
    end

    context 'when there is no match for any pattern using .btn:hover {opacity:0.7}' do
      let(:buffer) { StringScanner.new('.btn:hover {opacity:0.7}') }

      it 'does not return a truthy value for /\. [a-zA-Z0-9-]/' do
        pattern = /\. [a-zA-Z0-9-]/
        result = validate_pattern.send(:check_match, buffer, pattern)
        expect(result).to_not be_truthy
      end

      it 'does not return a truthy value for /\.[a-zA-Z0-9-]+\{/' do
        pattern = /\.[a-zA-Z0-9-]+\{/
        result = validate_pattern.send(:check_match, buffer, pattern)
        expect(result).to_not be_truthy
      end

      it 'does not return a truthy value for /\.[a-zA-Z0-9-]+\s{\s*}/' do
        pattern = /\.[a-zA-Z0-9-]+\s{\s*}/
        result = validate_pattern.send(:check_match, buffer, pattern)
        expect(result).to_not be_truthy
      end
    end
  end

  describe '#display_error' do
    subject(:validate_message) { described_class.new }
    let(:buffer) { StringScanner.new('. ticket-wrapper {') }

    it 'returns a message indicating line number, position, and error message' do
      expected_message = "ERROR on line 1, position 3: '. t'' => "\
      'There should be no empty space after calling a class selector '
      msg = 'There should be no empty space after calling a class selector'
      validate_message.instance_variable_set(:@line_number, 1)
      buffer.scan_until(/\. [a-zA-Z0-9-]/)
      result = validate_message.send(:display_error, buffer, msg)
      expect(result).to eq(expected_message)
    end
  end
end
