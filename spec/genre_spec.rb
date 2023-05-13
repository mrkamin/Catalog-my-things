require_relative '../classes/genre'
require_relative '../classes/item'

describe Genre do
  test_genre = Genre.new('test')
  item = Item.new('2008/05/05')
  it 'test_genre should return "test" as its name' do
    expect(test_genre.name).to eq('test')
  end

  it 'After adding one item "item" to test_genre its items array should include "item"' do
    test_genre.add_item(item)

    expect(test_genre.items.include?(item)).to be true
  end
end
