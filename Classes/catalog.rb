class Catalog
  attr_reader :books, :labels

  def initialize
    @books = []
    @labels = []
  end

  def add_book(book)
    @books << book
  end

  def add_label(label)
    @labels << label
  end
end
