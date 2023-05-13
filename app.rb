require 'fileutils'
require 'json'
require_relative './Classes/catalog'
require_relative './Classes/book'
require_relative './Classes/label'
require_relative './Classes/music'
require_relative './Classes/genre'
require_relative './Classes/author'
require_relative './Classes/game'

class App
  def initialize
    @things = Catalog.new
    read_all_data
  end

  def enter_date
    loop do
      timedate = gets.chomp
      format = '%Y/%m/%d'
      DateTime.strptime(timedate, format)
      return timedate
    rescue ArgumentError
      puts 'Please enter a valid timedate (yyyy/mm/dd):'
      return enter_date
    end
  end

  def choose_a_label(choose: false)
    list_all_labels(choose: choose)
    puts 'Choose label by number or enter "n" to add a new label'
    input = gets.chomp
    if input.downcase == 'n'
      add_a_label
      return @things.labels.last
    end
    @things.labels[input.to_i] unless @things.labels[input.to_i].nil?
  end

  def choose_a_genre(choose: false)
    list_all_genres(choose: choose)
    puts 'Choose genre by number or type "n" for new genre'
    input = gets.chomp
    if input.downcase == 'n'
      add_a_genre
      return @things.genres.last
    end
    @things.genres[input.to_i] unless @things.genres[input.to_i].nil?
  end

  def add_a_book
    puts 'Please fill book data:'
    puts 'Publish date:'
    publish_date = enter_date
    puts 'Publisher:'
    publisher = gets.chomp
    puts 'Cover state:'
    cover_state = gets.chomp
    book = Book.new(publish_date, publisher, cover_state)
    label = choose_a_label(choose: true)
    book.label = label if label.is_a? Label
    genre = choose_a_genre(choose: true)
    book.genre = genre if genre.is_a? Genre
    @things.add_a_book(book)
    puts 'Book added successfuly'
    puts 'Press enter to continue'
    gets.chomp
  end

  def list_all_books
    puts '****-------Books List--------****'
    list(@things.books)
    puts '****-----End of the List-----****'
    puts 'Press enter to continue'
    gets.chomp
  end

  def add_a_music
    puts 'Please fill Music data:'
    puts 'Publish date:'
    publish_date = enter_date
    puts 'Is it on Spotify? [y/n]:'
    it_is = gets[0].capitalize
    it_is = (it_is == 'Y')
    music = Music.new(publish_date, it_is)
    label = choose_a_label(choose: true)
    music.label = label if label.is_a? Label
    genre = choose_a_genre(choose: true)
    music.genre = genre if genre.is_a? Genre
    @things.add_a_music(music)
    puts 'music added successfuly'
    puts 'Press enter to continue'
    gets.chomp
  end

  def list_all_musics
    puts '------------musics List-----------'
    list(@things.musics)
    puts '----------End of the List----------'
    puts 'Press Enter to continue'
    gets.chomp
  end

  def add_a_game
    puts 'Please fill game data:'
    puts 'Publish date:'
    publish_date = enter_date
    puts 'Last played:'
    last_played = enter_date
    puts 'Multiplayer:'
    multiplayer = gets.chomp
    game = Game.new(publish_date, last_played, multiplayer)
    @things.add_a_game(game)
    puts 'Game added successfuly'
    puts 'Press enter to continue'
    gets.chomp
  end

  def list_all_games
    puts '------------Games List-----------'
    list(@things.games)
    puts '----------End of the List----------'
    puts 'Press enter to continue'
    gets.chomp
  end

  def add_a_label
    puts 'Please fill label data:'
    print 'Title: '
    title = gets.chomp
    print 'Color: '
    color = gets.chomp
    @things.add_a_label(Label.new(title, color))
    puts 'Label added successfuly'
    puts 'Press enter to continue'
    gets.chomp
  end

  def list_all_labels(choose: false)
    puts '------------Labels List-----------'
    list(@things.labels)
    puts '----------End of the List----------'
    return if choose

    puts 'Press enter to continue'
    gets.chomp
  end

  def add_a_genre
    puts 'Please fill genre data:'
    print 'Name: '
    name = gets.chomp
    @things.add_a_genre(Genre.new(name))
    puts 'Genre added successfuly'
    puts 'Press enter to continue'
    gets.chomp
  end

  def list_all_genres(choose: false)
    puts '------------Genres List-----------'
    list(@things.genres)
    puts '----------End of the List----------'
    return if choose

    puts 'Press enter to continue'
    gets.chomp
  end

  def add_a_author
    puts 'Please fill author data:'
    print 'First Name: '
    first_name = gets.chomp
    print 'Last Name: '
    last_name = gets.chomp
    @things.add_a_author(Author.new(first_name, last_name))
    puts 'Author added successfuly'
    puts 'Press enter to continue'
    gets.chomp
  end

  def list_all_authors(choose: false)
    puts '------------Authors List-----------'
    list(@things.authors)
    puts '----------End of the List----------'
    return if choose

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
      @things.add_a_book(Book.new(item['publish_date'], item['publisher'], item['cover_state']))
    end
    read_list('games.json') do |item|
      @things.add_a_game(Game.new(item['publish_date'], item['last_played'], item['multiplayer']))
    end
    read_list('musics.json') { |item| @things.add_a_music(Music.new(item['publish_date'], item['on_spotify'])) }
    read_list('genres.json') { |item| @things.add_a_genre(Genre.new(item['name'])) }
    read_list('authors.json') { |item| @things.add_a_author(Author.new(item['first_name'], item['last_name'])) }
    read_list('labels.json') { |item| @things.add_a_label(Label.new(item['title'], item['color'])) }
  end

  def read_list(file_name, &block)
    return unless File.exist?("./app_data/#{file_name}")

    items = JSON.parse(File.read("./app_data/#{file_name}"))

    items.each(&block)
  end

  def save_data
    save_list('books.json', @things.books)
    save_list('musics.json', @things.musics)
    save_list('games.json', @things.games)
    save_list('authors.json', @things.authors)
    save_list('labels.json', @things.labels)
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
end
