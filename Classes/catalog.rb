class Catalog
  attr_reader :books, :labels, :sources, :authors, :games, :musics

  def initialize
    @books = []
    @labels = []
    @sources = []
    @games = []
    @authors = []
    @musics = []
  end

  def add_music(music)
    @musics << music
  end

  def add_game(game)
    @games << game
  end

  def add_author(author)
    @authors << author
  end
end
