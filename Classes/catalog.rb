class Catalog
  attr_reader :books, :labels, :sources, :authors, :games

  def initialize
    @books = []
    @labels = []
    @sources = []
    @games = []
    @authors = []
  end

  def add_book(book)
    @books << book
  end

  def add_label(label)
    @labels << label
  end

  def add_source(source)
    @sources << source
  end

  def add_game(game)
    @games << game
  end

  def add_author(author)
    @authors << author
  end
end
