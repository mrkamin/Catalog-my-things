# require 'set'

module ListAllGenres
  def list_all_genres
    puts '------------Genre List-----------'
    list(@things.genres)
    puts '----------End of the Genre List----------'
    puts 'Press enter to continue'
    gets.chomp
  end
end
