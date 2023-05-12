require_relative '../Classes/genre'
require_relative '../Classes/music'
require_relative '../Classes/catalog'

module AddMusicAlbum
  def add_a_music
    print 'Genre : '
    name = gets.chomp

    print 'Name : '
    album_name = gets.chomp

    print 'On spotify? Y/N : '
    on_spotify = gets.chomp.downcase[0..1] == 'y'

    print 'Album publish date (DD/MM/YYYY) : '
    publish_date = gets.chomp

    genre = Genre.new(name)
    album = Music.new(album_name, on_spotify, publish_date)
    album.genre = genre
   
    @things.add_music(album)

    puts 'Music album added successfully'
  end
end
