require 'strscan'
require_relative '../lib/check_rules'

class Validate
  attr_reader :rules, :line_number, :line_errors

  def initialize
    @rules = [TrailingSpaceClass.new, TrailingSpaceID.new, SpaceBeforeCurlyClass.new, SpaceBeforeCurlyID.new,
              EmptyRule.new]
    @line_number = 0
    @line_errors = false
  end

  def start(file)
    file.each_line { |line| validate_line(scan_line(line)) }
  end

  def create_buffer(line)
    StringScanner.new(line)
  end

  private

  def scan_line(line)
    StringScanner.new(line)
  end

  def check_match(buffer, regxp)
    buffer.check_until(regxp)
  end

  def validate_line(buffer)
    @line_number += 1
    @rules.each do |rule|
      next unless check_match(buffer, rule.regxp)

      @line_errors = true unless line_errors
      buffer.scan_until(rule.regxp)
      puts display_error(buffer, rule.error_message)
      buffer.reset
    end
  end

  def display_error(buffer, err_msg)
    "ERROR on line #{@line_number}, position #{buffer.pos}: '#{buffer.matched}'' => #{err_msg} "
  end
end
