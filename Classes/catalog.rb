class Catalog
  attr_reader :musics, :genres

  def initialize
    @musics = []
    @genres = []
  end

  def add_music(music)
    @musics << music
  end
  def add_genres(genre) 
   @genres << genre
  end
end
