require 'rspec'
require 'spec_helper'
require 'nokogiri'
require_relative '../lib/google_parser'
require_relative 'support/shared_examples/artwork_examples'
require_relative 'support/shared_examples/van_gogh_examples'
require_relative 'support/shared_examples/no_results_examples'
require_relative 'support/shared_examples/tesla_inventions_examples'

RSpec.describe GoogleParser do
  describe '#parse' do
    context 'when the html contains a grid carousel' do
      let(:html) { File.read('spec/files/grid/van-gogh-paintings.html') }
      let(:google_parser) { GoogleParser.new(html: html) }
      let(:parsed_carousel) { google_parser.parse }

      it_behaves_like 'a google parser'
    end

    context 'when the html does not contain a grid carousel' do
      let(:html) { File.read('spec/files/grid/no-carousel.html') }
      let(:empty_google_parser) { GoogleParser.new(html: html) }
      let(:missing_parsed_carousel) { empty_google_parser.parse }

      it_behaves_like 'no results found'
    end
  end

  context 'Grid carousel of Van Gogh Paintings' do
    let(:html) { File.read('spec/files/grid/van-gogh-paintings.html') }
    let(:google_parser) { GoogleParser.new(html: html) }
    let(:parsed_carousel) { google_parser.parse }

    it_behaves_like 'van gogh artworks'
  end

  context 'Tab list carousel of Tesla Inventions' do
    let(:html) { File.read('spec/files/tab_list/list-of-tesla-inventions.html') }
    let(:google_parser) { GoogleParser.new(html: html) }
    let(:parsed_carousel) { google_parser.parse }

    it_behaves_like 'tesla inventions'
  end

  context 'when the html contains a tab_list carousel' do
    let(:html) { File.read('spec/files/tab_list/list-of-tesla-inventions.html') }
    let(:google_parser) { GoogleParser.new(html: html) }
    let(:parsed_carousel) { google_parser.parse }

    it_behaves_like 'a google parser'
  end

  context 'when the html does not contain a tab_list carousel nor a grid carousel' do
    let(:html) { File.read('spec/files/tab_list/no-carousel.html') }
    let(:empty_google_parser) { GoogleParser.new(html: html) }
    let(:missing_parsed_carousel) { empty_google_parser.parse }

    it_behaves_like 'no results found'
  end
end
