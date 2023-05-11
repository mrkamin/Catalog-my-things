require_relative './author'
require_relative './game'

class App
  def initialize
    @authors = []
    @games = []
    print_menu
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
      12 => { text: 'Add an author', action: proc { add_author } },
      0 => { text: 'Exit from App' }
    }
  end

  def print_menu
    loop do
      options.each { |k, v| print "#{k} - #{v[:text]} \n" }
      choice = gets.chomp.to_i
      choice_menu(choice)
    end
  end

  def choice_menu(choice)
    case choice
    when 3
      list_games
    when 9
      add_game
    when 6
      list_authors
    when 12
      add_author
    when 0
      puts 'Thank you for using this app!'
      exit
    else
      puts 'Invalid choice!'
    end
  end

  def add_author
    puts 'Enter First Name: '
    first_name = gets.chomp
    puts 'Enter Last Name: '
    last_name = gets.chomp

    @authors << Author.new(first_name, last_name)
    puts 'Add author successful!'
  end

  def list_authors
    puts 'Oops, no authors registered yet!' if @authors.empty?
    @authors.each do |author|
      puts "ID: #{author.id}, Name: #{author.first_name} #{author.last_name}"
    end
  end

  def add_game
    puts 'Enter Publish Year: '
    publish_date = gets.chomp
    puts 'Enter Multiplayer: [Y/N]'
    multiplayer_choice = gets.chomp.downcase
    multiplayer = true if multiplayer_choice = 'y'
    multiplayer = false if multiplayer_choice = 'n'
    puts 'Enter Last played Year: '
    last_played_at = gets.chomp

    @games << Game.new(publish_date, multiplayer, last_played_at)
    puts 'Add game succeessful!'
  end

  def list_games
    puts 'Oops, no games created yet!' if @games.empty?
    @games.each do |game|
      puts "ID: #{game.id}, Publish Date: #{game.publish_date}, "
      puts "Multiplayer: #{game.multiplayer}, Last Played At: #{game.last_played_at}"
    end
  end
end
