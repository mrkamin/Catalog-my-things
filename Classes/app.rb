require 'fileutils'
require 'json'
require_relative './catalog'
require_relative './book'
require_relative './label'
require_relative './genre'
require_relative './author'
require_relative './source'
require_relative './music'

# modules
require_relative '../modules/menu'
require_relative '../modules/list_all_music_album'
require_relative '../modules/list_all_genres'
require_relative '../modules/add_music_album'

# ACTIONS = {
#   1 => :list_all_musics,
#   2 => :list_all_genres,
#   3 => :add_a_music
# }.freeze

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
  include AddMusicAlbum
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

  def choos_genre(choos: false)
    list_genres(choos: choos)
    puts 'Choose genre by number or enter "n" for a new genre'
    input = gets.chomp
    if input.downcase == 'n'
      add_genre
      return @things.genres.last
    end
    @things.genres[input.to_i] unless @things.genres[input.to_i].nil?
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
    genre = choos_genre(choos: true)
    music.genre = genre if genre.is_a? Genre
    @things.add_music(music)
    puts 'Music added successfuly'
    puts 'Press enter to continue'
    gets.chomp
  end

  def add_genre
    puts 'Please fill below genre data:'
    print 'Name: '
    name = gets.chomp
    @things.add_genres(Genre.new(name))
    puts 'Genre added successfuly'
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

    read_list('books.json') do |item|
      @things.add_book(Book.new(item['publish_date'], item['cover_state'], item['publisher']))
    end
    read_list('genres.json') { |item| @things.add_genre(Genre.new(item['name'])) }
    read_list('musics.json') do |item|
      @things.add_music(Music.new(item['publish_date'], item['name'], item['spotify']))
    end
    read_list('authors.json') { |item| @things.add_author(Author.new(item['first_name'], item['last_name'])) }

    read_list('games.json') do |game|
      @things.add_game(Game.new(game['multiplayer'], game['last_played_at'], game['publish_date']))
    end
    read_list('sources.json') { |item| @things.add_source(Source.new(item['book_source'])) }
    read_list('labels.json') { |item| @things.add_label(Label.new(item['title'])) }

    read_list('musics.json') do |item|
      @things.add_music(Music.new(item['publish_date'], item['name'], item['spotify']))
    end
    read_list('genres.json') { |item| @things.add_genres(Genre.new(item['name'])) }

  end

  def read_list(file_name, &block)
    return unless File.exist?("./app_data/#{file_name}")

    items = JSON.parse(File.read("./app_data/#{file_name}"))

    items.each(&block)
  end

  def save_data
    save_list('musics.json', @things.musics)
    save_list('genres.json', @things.genres)
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


  def choos_label(choos: false)
    list_labels(choos: choos)
    puts 'Choos a label or type "n" for a new label'
    input = gets.chomp
    if input.downcase == 'n'
      add_label
      return @things.labels.last
    end
    @things.labels[input.to_i] unless @things.labels[input.to_i].nil?
  end

  def choos_source(choos: false)
    list_sources(choos: choos)
    puts 'choos a Source or type "n" for a new Source'
    input = gets.chomp
    if input.downcase == 'n'
      add_source
      return @things.sources.last
    end
    @things.sources[input.to_i] unless @things.sources[input.to_i].nil?
  end

  def choos_genre(choos: false)
    list_genres(choos: choos)
    puts 'Choos genre by number or enter "n" for a new genre'
    input = gets.chomp
    if input.downcase == 'n'
      add_genre
      return @things.genres.last
    end
    @things.genres[input.to_i] unless @things.genres[input.to_i].nil?
  end

  def choos_author(choos: false)
    list_authors(choos: choos)
    puts 'Choos author by number or enter "n" for a new author'
    input = gets.chomp
    if input.downcase == 'n'
      add_author
      return @things.authors.last
    end
    @things.authors[input.to_i] unless @things.authors[input.to_i].nil?
  end

  def add_book
    puts 'Please fill below book data:'
    puts 'Publish date:'
    publish_date = enter_date
    puts 'Publisher:'
    publisher = gets.chomp
    puts 'Cover state:'
    cover_state = gets.chomp
    book = Book.new(publisher, cover_state, publish_date)
    genre = choos_genre(choos: true)
    book.genre = genre if genre.is_a? Genre
    source = choos_source(choos: true)
    book.source = source if source.is_a? Source
    label = choos_label(choos: true)
    book.label = label if label.is_a? Label
    author = choos_author(choos: true)
    book.author = author if author.is_a? Author

    @things.add_book(book)
    puts 'Book added successfuly'
    puts 'Press enter to continue'
    gets.chomp
  end

  def list_books
    puts '------------Books List-----------'
    list(@things.books)

  def list_musics
    puts '------------Musics List-----------'
    list(@things.musics)

    puts '----------End of the List----------'
    puts 'Press enter to continue'
    gets.chomp
  end

  def list_genres(choos: false)
    puts '------------Genres List-----------'
    list(@things.genres)
    puts '----------End of the List----------'
    return if choos

    puts 'Press Enter to Continue'
    gets.chomp
  end

  def add_author
    puts 'Enter First Name: '
    first_name = gets.chomp
    puts 'Enter Last Name: '
    last_name = gets.chomp

    @things.add_author(Author.new(first_name, last_name))
    puts 'Add author successful!'
    puts 'Press Enter to continue'
    gets.chomp
  end

  def list_authors(choos: false)
    puts '***--------Authors List-----------***'
    list(@things.authors)
    puts '***----End of the Authors list-----***'
    return if choos

    puts 'Press Enter to Continue'
    gets.chomp
  end

  def add_genre
    puts 'Please fill below genre data:'
    print 'Name: '
    name = gets.chomp
    @things.add_genre(Genre.new(name))
    puts 'Genre added successfuly'
    puts 'Press enter to continue'
    gets.chomp
  end

  def list_genres(choos: false)
    puts '------------Genres List-----------'
    list(@things.genres)
    puts '----------End of the List----------'
    return if choos

    puts 'Press enter to continue'
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

  def options
    {
      1 => { text: 'List all Musics', action: proc { list_musics } },
      2 => { text: 'List all Genres', action: proc { list_genres } },
      3 => { text: 'Add a Music', action: proc { add_music } },
      4 => { text: 'Add a Genre', action: proc { add_genre } },
      5 => { text: 'Exit App' }
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
    return unless options.keys.include?(choice)

    options[choice][:action].call
  end
end
