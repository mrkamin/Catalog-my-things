class Source
  attr_accessor :id
  attr_reader :book_source, :items

  def initialize(book_source)
    @book_source = book_source
    @items = []
    @id = Random.rand(1..1000)
  end

  def add_item(item)
    @items << item
    item.book_source = self
  end

  def as_hash
    {
      'book_source' => @book_source
    }
  end
end
