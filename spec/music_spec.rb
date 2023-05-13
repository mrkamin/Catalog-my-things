require_relative '../classes/music'
require_relative '../classes/genre'
require_relative '../classes/label'

describe Music do
  music = Music.new('02/06/2004', true)
  genre = Genre.new('test-Genre')

  it 'music should return "02/06/2004" as its publish_date and "true" as its spotify status' do
    expect(music.publish_date).to eq('02/06/2004')
    expect(music.on_spotify).to eq(true)
  end

  it 'After assigning genre as music genre music.genre should equal genre' do
    music.genre = genre

    expect(music.genre).to eq genre
  end

  it 'test assign author to music' do
    author = double('author', 'items' => [])

    music.author = author
    expect(music.author).to eq author
  end

  it 'test assign label to music' do
    label = Label.new('label', 'Blue')

    music.label = label
    expect(music.label).to eq label
  end

  it 'test music can_be_archived should return true as the on_spotify is set to true' do
    expect(music.can_be_archived?).to be true
  end

  it 'test music archived status, it should return false before calling move_to_archive and true afterwards' do
    expect(music.archived).to be false
    music.move_to_archive
    expect(music.archived).to be true
  end
end
