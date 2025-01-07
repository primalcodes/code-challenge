RSpec.shared_examples 'van gogh artworks' do
  it 'finds the correct number of artworks' do
    correct_number_of_artworks = 47
    expect(parsed_carousel[:artworks].length).to eq(correct_number_of_artworks)
  end

  it 'finds the Starry Night artwork' do
    artwork_title = 'The Starry Night'
    artwork = parsed_carousel[:artworks].find { |item| item[:name] == artwork_title }

    expect(artwork[:image]).to include('data:image/jpeg;base64')
    expect(artwork[:link]).to include('https://www.google.com/search?')
    expect(artwork[:extensions]).to include('1889')
  end
end
