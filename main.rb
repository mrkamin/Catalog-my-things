require './Classes/app'
# require_relative './Classes/app'
require_relative './modules/menu'

def main
  puts '********-------------------------********'
  puts '       Welcome to  Catalog of Things      '
  puts "********-------------------------********\n"
  App.new
end

main
