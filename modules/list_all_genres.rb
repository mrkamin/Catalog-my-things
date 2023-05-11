require 'set'

module ListAllGenres
  def list_all_genres
    puts 'Genres:'
    genres = Set.new
    @music.each do |music|
      genres << music.genre.name.to_s
    end
    genres.each do |genre|
      puts "- #{genre}"
    end
  end
end
