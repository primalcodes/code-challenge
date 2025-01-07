require 'rspec'
require 'spec_helper'
require 'nokogiri'
require_relative '../../lib/google_carousel_parser/tab_list'
require_relative '../support/shared_examples/artwork_examples'
require_relative '../support/shared_examples/no_results_examples'
require_relative '../support/shared_examples/tesla_inventions_examples'

# Generate Rspec test for Google Carousel TabList Carousel class
RSpec.describe GoogleCarouselParser::TabList do
  describe '#parse' do
    context 'when the html contains a tab_list carousel' do
      let(:html) { File.read('spec/files/tab_list/list-of-tesla-inventions.html') }
      let(:tab_list_carousel) { GoogleCarouselParser::TabList.new(html_doc: Nokogiri::HTML(html)) }
      let(:parsed_carousel) { tab_list_carousel.parse }

      it_behaves_like 'a google parser'
    end

    context 'when the html does not contain a tab_list carousel' do
      let(:html) { File.read('spec/files/tab_list/no-carousel.html') }
      let(:empty_tab_list_carousel) { GoogleCarouselParser::TabList.new(html_doc: Nokogiri::HTML(html)) }
      let(:missing_parsed_carousel) { empty_tab_list_carousel.parse }

      it_behaves_like 'no results found'
    end
  end

  context 'List of Tesla Inventions' do
    let(:html) { File.read('spec/files/tab_list/list-of-tesla-inventions.html') }
    let(:tab_list_carousel) { GoogleCarouselParser::TabList.new(html_doc: Nokogiri::HTML(html)) }
    let(:parsed_carousel) { tab_list_carousel.parse }

    it_behaves_like 'tesla inventions'
  end

  context 'List of Presidents' do
    let(:html) { File.read('spec/files/tab_list/list-of-presidents.html') }
    let(:tab_list_carousel) { GoogleCarouselParser::TabList.new(html_doc: Nokogiri::HTML(html)) }
    let(:parsed_carousel) { tab_list_carousel.parse }

    it 'finds the correct number of artworks' do
      correct_number_of_artworks = 46
      expect(parsed_carousel[:artworks].length).to eq(correct_number_of_artworks)
    end

    it 'finds John F. Kennedy' do
      artwork_title = 'John F. Kennedy'
      artwork = parsed_carousel[:artworks].find { |item| item[:name] == artwork_title }

      expect(artwork[:image]).to include('data:image/jpeg;base64')
      expect(artwork[:link]).to include('https://www.google.com/search?')
      expect(artwork[:extensions]).to include('(1961-1963)')
    end
  end

  context 'List of Popes' do
    let(:html) { File.read('spec/files/tab_list/list-of-popes.html') }
    let(:tab_list_carousel) { GoogleCarouselParser::TabList.new(html_doc: Nokogiri::HTML(html)) }
    let(:parsed_carousel) { tab_list_carousel.parse }

    it 'finds the correct number of artworks' do
      correct_number_of_artworks = 50
      expect(parsed_carousel[:artworks].length).to eq(correct_number_of_artworks)
    end

    it 'finds the Pope John Paul II entry' do
      artwork_title = 'Pope John Paul II'
      artwork = parsed_carousel[:artworks].find { |item| item[:name] == artwork_title }

      expect(artwork[:image]).to include('data:image/jpeg;base64')
      expect(artwork[:link]).to include('https://www.google.com/search?')
      expect(artwork[:extensions]).to include('(1978-2005)')
    end
  end
end
