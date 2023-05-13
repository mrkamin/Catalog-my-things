require './app'

def menu
  puts '
  1: List all books
  2: List all musics
  3: List all games
  4: List all labels
  5: List all genres
  6: List all authors
  7: Add a book
  8: Add a music
  9: Add a game
  10: Add a label
  11: Add a genre
  12: Add a author
  0: Exit
  '
  puts 'Please kindly choose a number: '
end

ACTIONS = {
  1 => :list_all_books,
  2 => :list_all_musics,
  3 => :list_all_games,
  4 => :list_all_labels,
  5 => :list_all_genres,
  6 => :list_all_authors,
  7 => :add_a_book,
  8 => :add_a_music,
  9 => :add_a_game,
  10 => :add_a_label,
  11 => :add_a_genre,
  12 => :add_a_author
}.freeze

def main
  puts '********-------------------------********'
  puts '       Welcome to  Catalog of Things      '
  puts "********-------------------------********\n"
  menu
  app = App.new
  while (choice = gets.to_i)
    if choice.zero?
      puts 'Hope you enjoyed using this app. Good bye!'
      app.save_data
      exit
    end
    method_name = ACTIONS[choice]
    if method_name.nil?
      puts 'Incorrect! Must be between 1-12. Please try again...'
    else
      method_tocall = app.method(method_name)
      method_tocall.call
    end
    menu
  end
end

main
