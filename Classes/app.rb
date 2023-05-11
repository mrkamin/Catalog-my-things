require 'fileutils'
require 'json'
require_relative './catalog'
require_relative './book'
require_relative './label'
require_relative './genre'
require_relative './author'
require_relative './game'
require_relative './source'
# rubocop:disable Metrics/ClassLength

class App
  def initialize
    @things = Catalog.new
    read_all_data
    print_chose_list
    @authors = []
    @games = []
    print_menu
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
    @things.sources[input.to_i] unless @things.labels[input.to_i].nil?
  end

  def add_book
    puts 'Please fill below book data:'
    puts 'Publish date:'
    publish_date = enter_date
    puts 'Publisher:'
    publisher = gets.chomp
    puts 'Cover state:'
    cover_state = gets.chomp
    book = Book.new(publish_date, publisher, cover_state)
    label = choos_label(choos: true)
    book.label = label if label.is_a? Label
    source = choos_source(choos: true)
    book.source = source if source.is_a? Source
    @things.add_book(book)
    puts 'Book added successfuly'
    puts 'Press enter to continue'
    gets.chomp
  end

  def add_label
    puts 'Please add a label:'
    print 'Title: '
    title = gets.chomp
    @things.add_label(Label.new(title))
    puts 'Label added successful'
    puts 'Press Enter to continue'
    gets.chomp
  end

  def add_source
    puts 'Please add a Scourc'
    print 'Book_source: '
    book_source = gets.chomp
    @things.add_source(Source.new(book_source))
    puts 'Source added Successful'
    puts 'press Enter to Continue'
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
      @things.add_book(Book.new(item['publish_date'], item['publisher'], item['cover_state']))
    end
    read_list('labels.json') { |item| @things.add_label(Label.new(item['title'])) }
    read_list('sources.json') { |item| @things.add_source(Source.new(item['book_source'])) }
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

  def list_books
    puts '------------Books List-----------'
    list(@things.books)
    puts '----------End of the List----------'
    puts 'Press enter to continue'
    gets.chomp
  end

  def list_labels(choos: false)
    puts '***--------Labels List-----------***'
    list(@things.labels)
    puts '***----End of the label list-----***'
    return if choos

    puts 'Press Enter to Continue'
    gets.chomp
  end

  def list_sources(choos: false)
    puts '***---------Sources List--------***'
    list(@things.sources)
    puts '***---End of the Sources list---***'
    return if choos

    puts 'Press Enter to Continue'
    gets.chomp
  end

  def options
    {
      1 => { text: 'List of all Books', action: proc { list_books } },
      2 => { text: 'List of all music', action: proc { list_albums } },
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

  def print_chose_list
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
    multiplayer = true if multiplayer_choice == 'y'
    multiplayer = false if multiplayer_choice == 'n'
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
    return unless options.keys.include?(choice)

    options[choice][:action].call
  end
end
# rubocop:enable Metrics/ClassLength
