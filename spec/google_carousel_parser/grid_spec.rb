require 'rspec'
require 'spec_helper'
require 'nokogiri'
require_relative '../../lib/google_carousel_parser/grid'

# Generate Rspec test for Google Carousel Grid Carousel class
RSpec.describe GoogleCarouselParser::Grid do
  describe '#parse' do
    context 'when the html contains a grid carousel' do
      let(:html) { File.read('spec/files/grid/van-gogh-paintings.html') }
      let(:grid_carousel) { GoogleCarouselParser::Grid.new(html_doc: Nokogiri::HTML(html)) }
      let(:parsed_carousel) { grid_carousel.parse }

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

    context 'when the html does not contain a grid carousel' do
      let(:html) { File.read('spec/files/grid/no-carousel.html') }
      let(:empty_grid_carousel) { GoogleCarouselParser::Grid.new(html_doc: Nokogiri::HTML(html)) }
      let(:missing_parsed_carousel) { empty_grid_carousel.parse }

      it 'returns empty artworks array' do
        expect(missing_parsed_carousel).to eq(
          {
            artworks: []
          }
        )
      end
    end
  end

  context 'Van Gogh Paintings' do
    let(:html) { File.read('spec/files/grid/van-gogh-paintings.html') }
    let(:grid_carousel) { GoogleCarouselParser::Grid.new(html_doc: Nokogiri::HTML(html)) }
    let(:parsed_carousel) { grid_carousel.parse }

    it 'finds the correct number of artworks' do
      correct_number_of_artworks = 47
      expect(parsed_carousel[:artworks].length).to eq(correct_number_of_artworks)
    end

    it 'finds the Starry Night artwork' do
      artwork_title = 'The Starry Night'
      starry_night = parsed_carousel[:artworks].find { |artwork| artwork[:name] == artwork_title }

      expect(starry_night[:image]).to include('data:image/jpeg;base64')
      expect(starry_night[:link]).to include('https://www.google.com/search?')
      expect(starry_night[:extensions]).to include('1889')
    end
  end

  context 'Picasso Sculptures' do
    let(:html) { File.read('spec/files/grid/picasso-sculptures.html') }
    let(:grid_carousel) { GoogleCarouselParser::Grid.new(html_doc: Nokogiri::HTML(html)) }
    let(:parsed_carousel) { grid_carousel.parse }

    it 'finds the correct number of artworks' do
      correct_number_of_artworks = 46
      expect(parsed_carousel[:artworks].length).to eq(correct_number_of_artworks)
    end

    it 'finds The Old Guitarist artwork' do
      artwork_title = 'The Old Guitarist'
      artwork = parsed_carousel[:artworks].find { |item| item[:name] == artwork_title }

      expect(artwork[:image]).to include('data:image/jpeg;base64')
      expect(artwork[:link]).to include('https://www.google.com/search?')
      expect(artwork[:extensions]).to include('1904')
    end
  end

  context 'Michelangelo Artworks' do
    let(:html) { File.read('spec/files/grid/michelangelo-artworks.html') }
    let(:grid_carousel) { GoogleCarouselParser::Grid.new(html_doc: Nokogiri::HTML(html)) }
    let(:parsed_carousel) { grid_carousel.parse }

    it 'finds the correct number of artworks' do
      correct_number_of_artworks = 40
      expect(parsed_carousel[:artworks].length).to eq(correct_number_of_artworks)
    end

    it 'finds the Bacchus artwork' do
      artwork_title = 'Bacchus'
      artwork = parsed_carousel[:artworks].find { |item| item[:name] == artwork_title }

      expect(artwork[:image]).to include('data:image/jpeg;base64')
      expect(artwork[:link]).to include('https://www.google.com/search?')
      expect(artwork[:extensions]).to include('1497')
    end
  end
end
