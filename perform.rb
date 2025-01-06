# File to run the program
# `ruby perform.rb`

require_relative 'lib/google_parser'

# Loop through all .html files in the files directory to parse the HTML
# and output the results

files = Dir[File.join(File.dirname(__FILE__), 'files', '*.html')]
files.each do |file|
  html = File.read(file)
  results = GoogleParser.new(html: html).parse

  puts "Results for #{file}"
  puts results
  puts
end
