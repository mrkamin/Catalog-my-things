require 'fileutils'
require 'json'
require_relative './catalog'
require_relative './book'
require_relative './label'
require_relative './genre'
require_relative './author'
require_relative './game'
require_relative './source'
require_relative './music'

# modules
require_relative '../modules/menu'
require_relative '../modules/list_all_music_album'
require_relative '../modules/list_all_genres'
require_relative '../modules/add_music_album'

ACTIONS = {
  1 => :list_all_musics,
  2 => :list_all_genres,
  3 => :add_a_music
}.freeze

class App
  include Menu
  include AddMusicAlbum
  include ListAllGenres
  include ListAllMusics
  def run
    choice = 0

    while choice != 5
      desplay_menu
      choice = gets.chomp.to_i

      if choice == 4
        puts " \n Thanks for using catalog\n"
        exit
      end
      user_choice = ACTIONS[choice]

      method(user_choice).call
    end
  end

  def initialize
    @things = Catalog.new
    read_all_data
    print_chose_menu_list
  end

  def enter_date
    loop do
      date = gets.chomp
      format = '%m/%d/%Y'
      DateTime.strptime(date, format)
      return date
    rescue ArgumentError
      puts 'Please type a valid date (mm/dd/yyyy):'
      return enter_date
    end
  end

  def add_music
    puts 'Please fill below music data:'
    puts 'Publish date:'
    publish_date = enter_date
    puts 'name:'
    name = gets.chomp
    puts 'Is it Spotify? [y/n]:'
    it_is = gets[0].capitalize
    it_is = (it_is == 'Y')
    music = Music.new(name, publish_date, it_is)
    @things.add_music(music)
    puts 'Music added successfuly'
    puts 'Press enter to continue'
    gets.chomp
  end

  def list(list)
    list.each_with_index do |item, idx|
      print "#{idx}-"
      item.as_hash.each { |key, value| print "#{key}: #{value}   " unless value == '' }
      puts
    end
  end

  def read_all_data
    read_list('musics.json') do |item|
      @things.add_music(Music.new(item['publish_date'], item['name'], item['spotify']))
    end
    read_list('labels.json') { |item| @things.add_label(Label.new(item['title'])) }
    read_list('sources.json') { |item| @things.add_source(Source.new(item['book_source'])) }
    read_list('authors.json') do |author|
      @things.add_author(Author.new(author['first_name'], author['last_name']))
    end
    read_list('games.json') do |game|
      @things.add_game(Game.new(game['multiplayer'], game['last_played_at'], game['publish_date']))
    end
  end

  def read_list(file_name, &block)
    return unless File.exist?("./app_data/#{file_name}")

    items = JSON.parse(File.read("./app_data/#{file_name}"))

    items.each(&block)
  end

  def save_data
    save_list('books.json', @things.books)
    save_list('labels.json', @things.labels)
    save_list('sources.json', @things.sources)
    save_list('games.json', @things.games)
    save_list('authors.json', @things.authors)
    save_list('musics.json', @things.musics)
  end

  def save_list(file_name, list)
    FileUtils.mkdir_p('./app_data/')
    FileUtils.cd('./app_data/') do
      # generate json object
      list_json = []
      list.each { |item| list_json << item.as_hash }

      # write data to their respective files
      File.write(file_name, JSON.pretty_generate(list_json))
    end
  end

  def list_musics
    puts '------------Musics List-----------'
    list(@things.musics)
    puts '----------End of the List----------'
    puts 'Press enter to continue'
    gets.chomp
  end

  def options
    {
      1 => { text: 'List of all Books', action: proc { list_books } },
      2 => { text: 'List of all music', action: proc { list_musics } },
      3 => { text: 'List of all games', action: proc { list_games } },
      4 => { text: 'List of all genres', action: proc { list_genres } },
      5 => { text: 'List of all labels', action: proc { list_labels } },
      6 => { text: 'List of all Authors', action: proc { list_authors } },
      7 => { text: 'Add a book', action: proc { add_book } },
      8 => { text: 'Add a music', action: proc { add_music } },
      9 => { text: 'Add a game', action: proc { add_game } },
      10 => { text: 'Add a label', action: proc { add_label } },
      11 => { text: 'Add a genre', action: proc { add_genre } },
      12 => { text: 'Add an author', action: proc { add_author } },
      0 => { text: 'Exit from App' }
    }
  end

  def print_chose_menu_list
    loop do
      options.each { |k, v| print "#{k} - #{v[:text]} \n" }
      choice = gets.chomp.to_i
      if choice == options.keys.last
        puts "\nThank you for using the app\n"
        save_data
        break
      end
      puts "\e[H\e[2J"
      choice_menu(choice)
      puts "\e[H\e[2J"
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
    when 1
      list_books
    when 7
      add_book
    when 5
      list_labels
    when 10
      add_label
    when 2
      list_albums
    when 8
      add_album
    when 4
      list_genres
    when 11
      add_genre
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

    # @authors << Author.new(first_name, last_name)
    @things.add_author(Author.new(first_name, last_name))
    puts 'Add author successful!'
    puts 'Press Enter to continue'
    gets.chomp
  end

  def list_authors
    puts '***--------Authors List-----------***'
    list(@things.authors)
    puts '***----End of the Authors list-----***'

    puts 'Press Enter to Continue'
    gets.chomp
  end

  def add_game
    puts 'Enter Publish Year: '
    publish_date = gets.chomp
    puts 'Enter Multiplayer: [Y/N]'
    multiplayer_choice = gets.chomp.downcase
    multiplayer = true if multiplayer_choice == 'y'
    multiplayer = false if multiplayer_choice == 'n'
    puts 'Enter Last played Year: '
    last_played_at = gets.chomp

    game = Game.new(publish_date, multiplayer, last_played_at)
    @things.add_game(game)
    puts 'Add game succeessful!'
    puts 'Press enter to continue'
    gets.chomp
  end

  def list_games
    puts '------------Game List-----------'
    list(@things.games)
    puts '----------End of the Game List----------'
    puts 'Press enter to continue'
    gets.chomp
  end
end
