RSpec.shared_examples 'a google parser' do
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
