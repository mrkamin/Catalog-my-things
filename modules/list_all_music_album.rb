module ListAllMusics
  def list_all_musics
    puts '------------Musics List-----------'
    list(@things.musics)
    puts '----------End of the Music List----------'
    puts 'Press enter to continue'
    gets.chomp
  end
end
