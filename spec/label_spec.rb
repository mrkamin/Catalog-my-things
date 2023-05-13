require_relative '../classes/label'
require_relative '../classes/item'

describe Label do
  test_label = Label.new('test', 'black')
  item = Item.new('2008/05/05')
  it 'test_label should return "test" as its title and "black as its color object should return' do
    expect(test_label.title).to eq('test')
    expect(test_label.color).to eq('black')
  end

  it 'After adding one item "item" to test_label its items array should include "item"' do
    test_label.add_item(item)

    expect(test_label.items.include?(item)).to be true
  end
end
