require 'rspec'
require 'spec_helper'
require 'nokogiri'
require_relative '../../lib/google_carousel_parser/tab_list'

# Generate Rspec test for Google Carousel TabList Carousel class
RSpec.describe GoogleCarouselParser::TabList do
  describe '#parse' do
    context 'when the html contains a tab_list carousel' do
      let(:html) { File.read('spec/files/tab_list/list-of-tesla-inventions.html') }
      let(:tab_list_carousel) { GoogleCarouselParser::TabList.new(html_doc: Nokogiri::HTML(html)) }
      let(:parsed_carousel) { tab_list_carousel.parse }

      it 'returns a hash' do
        expect(parsed_carousel).to be_a(Hash)
      end

      it 'returns a hash with the key :artworks' do
        expect(parsed_carousel).to have_key(:artworks)
      end

      it 'returns a hash with the key :artworks that is an array' do
        expect(parsed_carousel[:artworks]).to be_an(Array)
      end

      it 'returns a hash with the key :artworks that is an array of hashes' do
        expect(parsed_carousel[:artworks].first).to be_a(Hash)
      end

      it 'returns a hash with the key :artworks that is an array of hashes with the keys :name, :image, :link, and :extensions' do
        expect(parsed_carousel[:artworks].first).to have_key(:name)
        expect(parsed_carousel[:artworks].first).to have_key(:image)
        expect(parsed_carousel[:artworks].first).to have_key(:link)
        expect(parsed_carousel[:artworks].first).to have_key(:extensions)
      end
    end

    context 'when the html does not contain a tab_list carousel' do
      let(:html) { File.read('spec/files/tab_list/no-carousel.html') }
      let(:empty_tab_list_carousel) { GoogleCarouselParser::TabList.new(html_doc: Nokogiri::HTML(html)) }
      let(:missing_parsed_carousel) { empty_tab_list_carousel.parse }

      it 'returns empty artworks array' do
        expect(missing_parsed_carousel).to eq(
          {
            artworks: []
          }
        )
      end
    end
  end

  context 'List of Tesla Inventions' do
    let(:html) { File.read('spec/files/tab_list/list-of-tesla-inventions.html') }
    let(:tab_list_carousel) { GoogleCarouselParser::TabList.new(html_doc: Nokogiri::HTML(html)) }
    let(:parsed_carousel) { tab_list_carousel.parse }

    it 'finds the correct number of artworks' do
      correct_number_of_artworks = 15
      expect(parsed_carousel[:artworks].length).to eq(correct_number_of_artworks)
    end

    it 'finds the Tesla drone artwork' do
      artwork_title = 'Tesla drone'
      artwork = parsed_carousel[:artworks].find { |item| item[:name] == artwork_title }

      expect(artwork[:image]).to include('data:image/png;base64')
      expect(artwork[:link]).to include('https://www.google.com/search?')
      expect(artwork[:extensions]).to be_empty
    end
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
