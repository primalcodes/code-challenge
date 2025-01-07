RSpec.shared_examples 'tesla inventions' do
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
