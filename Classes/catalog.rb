class Catalog
  attr_reader :books

  def initialize
    @books = []
  end

  def add_book(book)
    @books << book
  end
end
