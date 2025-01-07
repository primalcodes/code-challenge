require 'rspec'
require 'spec_helper'
require 'nokogiri'
require_relative '../../lib/google_carousel_parser/grid'
require_relative '../support/shared_examples/artwork_examples'
require_relative '../support/shared_examples/no_results_examples'
require_relative '../support/shared_examples/van_gogh_examples'

# Generate Rspec test for Google Carousel Grid Carousel class
RSpec.describe GoogleCarouselParser::Grid do
  describe '#parse' do
    context 'when the html contains a grid carousel' do
      let(:html) { File.read('spec/files/grid/van-gogh-paintings.html') }
      let(:grid_carousel) { GoogleCarouselParser::Grid.new(html_doc: Nokogiri::HTML(html)) }
      let(:parsed_carousel) { grid_carousel.parse }

      it_behaves_like 'a google parser'
    end

    context 'when the html does not contain a grid carousel' do
      let(:html) { File.read('spec/files/grid/no-carousel.html') }
      let(:empty_grid_carousel) { GoogleCarouselParser::Grid.new(html_doc: Nokogiri::HTML(html)) }
      let(:missing_parsed_carousel) { empty_grid_carousel.parse }

      it_behaves_like 'no results found'
    end
  end

  context 'Van Gogh Paintings' do
    let(:html) { File.read('spec/files/grid/van-gogh-paintings.html') }
    let(:grid_carousel) { GoogleCarouselParser::Grid.new(html_doc: Nokogiri::HTML(html)) }
    let(:parsed_carousel) { grid_carousel.parse }

    it_behaves_like 'van gogh artworks'
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
