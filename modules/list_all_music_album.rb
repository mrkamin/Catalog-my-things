module ListAllMusics
  def list_all_musics
    puts 'List of Music Albums:'
    @music_albums.each do |music|
      puts "- #{music.aname}"
    end
  end
end
