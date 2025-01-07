RSpec.shared_examples 'no results found' do
  it 'returns empty artworks array' do
    expect(missing_parsed_carousel).to eq(
      {
        artworks: []
      }
    )
  end
end
