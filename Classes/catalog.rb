class Catalog
  attr_reader :books, :labels, :sources

  def initialize
    @books = []
    @labels = []
    @sources = []
  end

  def add_book(book)
    @books << book
  end

  def add_label(label)
    @labels << label
  end

  def add_source(source)
    @sources << source
  end
end
