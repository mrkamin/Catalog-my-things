class Catalog
  attr_reader :books, :games, :musics, :labels, :genres, :authors

  def initialize
    @books = []
    @games = []
    @musics = []
    @labels = []
    @authors = []
    @genres = []
  end

  def add_a_book(book)
    @books << book
  end

  def add_a_game(game)
    @games << game
  end

  def add_a_music(music)
    @musics << music
  end

  def add_a_genre(genre)
    @genres << genre
  end

  def add_a_label(label)
    @labels << label
  end

  def add_a_author(author)
    @authors << author
  end
end
