class Catalog
  attr_reader :books, :labels, :sources, :authors, :games, :musics, :genres

  def initialize
    @books = []
    @labels = []
    @sources = []
    @games = []
    @authors = []
    @musics = []
    @genres = []
  end

  def add_label(label)
    @labels << label
  end

  def add_source(source)
    @sources << source
  end

  def add_book(book)
    @books << book
  end

  def add_music(music)
    @musics << music
  end

  def add_genre(genre)
    @genres << genre
  end

  def add_game(game)
    @games << game
  end

  def add_author(author)
    @authors << author
  end
end
