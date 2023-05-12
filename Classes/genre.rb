class Genre
  attr_accessor :name, :items
  attr_reader :id

  def initialize(name)
    @name = name
    @items = []
    @id = Random.rand(1..1000)
  end

  def add_item(item)
    @items << item
    item.genre = self
  end

  def as_hash
    {
      'name' => @name
    }
  end
end
