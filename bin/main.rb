#!/usr/bin/env ruby

require_relative '../lib/css_linter_logic'

file = 'lib/style.css'

f = File.open(file, 'r+')
new_validate = Validate.new
new_validate.start(f)
puts 'No errors were detected in the CSS file' unless new_validate.line_errors
