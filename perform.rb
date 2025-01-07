# File to run the program
# `ruby perform.rb`

require_relative 'lib/google_parser'
require 'json'

# Loop through all .html files in the files directory and parse the HTML
# and output the results as JSON

files = Dir[File.join(File.dirname(__FILE__), 'files', '*.html')]
files.each do |file|
  html = File.read(file)

  json_data = JSON.pretty_generate(GoogleParser.new(html: html).parse)
  file_basename = File.basename(file, '.html')
  json_file_name = File.join(File.dirname(__FILE__), 'files/json_output', "#{file_basename}.json")
  File.write(json_file_name, json_data)
end
