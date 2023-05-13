require_relative '../classes/book'
require_relative '../classes/genre'
require_relative '../classes/label'

describe Book do
  test_book1 = Book.new('2008/05/05', 'mrkamin-Inc', 'bad')
  genre = Genre.new('test-Genre')

  it 'test_book1 should return "2008/05/05" as its publish_date and "mrkamin-Inc" as its publisher' do
    expect(test_book1.publish_date).to eq('2008/05/05')
    expect(test_book1.publisher).to eq('mrkamin-Inc')
  end

  it 'After assigning genre as test_book1 genre test_book1.genre should equal genre' do
    test_book1.genre = genre

    expect(test_book1.genre).to eq genre
  end

  it 'test assign author to test_book1' do
    author = double('author', 'items' => [])

    test_book1.author = author
    expect(test_book1.author).to eq author
  end

  it 'test assign label to test_book1' do
    label = Label.new('label', 'Red')

    test_book1.label = label
    expect(test_book1.label).to eq label
  end

  it 'test book can_be_archived should return true as the cover_satate is set to bad' do
    expect(test_book1.can_be_archived?).to be true
  end

  it 'test book archived status, it should return false before calling move_to_archive and true afterwards' do
    expect(test_book1.archived).to be false
    test_book1.move_to_archive
    expect(test_book1.archived).to be true
  end
end
