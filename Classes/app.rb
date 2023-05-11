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
  end

  def read_list(file_name, &block)
    return unless File.exist?("./app_data/#{file_name}")

    items = JSON.parse(File.read("./app_data/#{file_name}"))

    items.each(&block)
  end

  def save_data
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
      1 => { text: 'List all Musics', action: proc { list_musics } },
      2 => { text: 'Add a Music', action: proc { add_music } },
      3 => { text: 'Exit App' }
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

