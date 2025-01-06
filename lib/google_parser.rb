# frozen_string_literal: true

require 'nokogiri'
require 'debug'
class GoogleParser
  attr_reader :doc, :scripts

  def initialize(html:)
    # Parse the HTML using Nokogiri here so we don't have to
    # re-parse the HTML in the parse method for each parser class
    @doc = Nokogiri::HTML(html)
  end

  def parse
    # Loop through classes in the "lib/grid_carousel_parser" directory to find the correct parser
    # for the given HTML
    files = Dir[File.join(File.dirname(__FILE__), 'google_carousel_parser', '*.rb')]

    puts files
    files.each do |file|
      puts file
      require file
      class_name = File.basename(file, '.rb').split('_').map(&:capitalize).join
      parser = Object.const_get("GoogleCarouselParser::#{class_name}").new(html_doc: @doc)
      results = parser.parse

      return results unless results == empty_results
    end

    # No results found
    empty_results
  end

  private

  def empty_results
    { artworks: [] }
  end
end
