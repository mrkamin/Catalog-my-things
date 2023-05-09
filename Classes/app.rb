class App
  def initialize
  end

  def options
    {
      1 => { text: 'List of all Books', action: proc { list_books } },
      2 => { text: 'List of all music', action: proc do
                                                  list_albums
                                                  puts 'Press enter to continue'
                                                  gets.chomp
                                                end },
      3 => { text: 'List of all games', action: proc { list_games } },
      4 => { text: 'List of all genres', action: proc { list_genres } },
      5 => { text: 'List of all labels', action: proc { list_labels } },
      6 => { text: 'List of all Authors', action: proc { list_authors } },
      7 => { text: 'Add a book', action: proc { add_book } },
      8 => { text: 'Add a music', action: proc { add_album } },
      9 => { text: 'Add a game', action: proc { add_game } },
      10 => { text: 'Add a label', action: proc { add_label } },
      11 => { text: 'Add a genre', action: proc { add_genre } },
      12 => { text: 'Exit from App' }
    }
  end
end
