class App
  def initialize
    @authors = []
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
      13 => { text: 'Exit from App' }
    }
  end

  def print_menu
    loop do
      options.each { |k, v| print "#{k} - #{v[:text]} \n" }
      choice = gets.chomp.to_i
      choice_menu(choice)
    end
  end

  def choice_menu(choice); end

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
end
