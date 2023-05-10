require 'fileutils'
require 'json'
require_relative './catalog'
require_relative './book'
require_relative './label'
require_relative './genre'
require_relative './author'
require_relative './source'
# rubocop:disable Metrics/ClassLength
class App
  def initialize
    @things = Catalog.new
    read_all_data
    print_chose_list
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
      1 => { text: 'List all books', action: proc { list_books } },
      2 => { text: 'List all Labels', action: proc { list_labels } },
      3 => { text: 'List all Sources', action: proc { list_sources } },
      4 => { text: 'Add a Book', action: proc { add_book } },
      5 => { text: 'Add a Label', action: proc { add_label } },
      6 => { text: 'Add a Source', action: proc { add_source } },
      7 => { text: 'Exit App' }
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
    return unless options.keys.include?(choice)

    options[choice][:action].call
  end
end
# rubocop:enable Metrics/ClassLength
