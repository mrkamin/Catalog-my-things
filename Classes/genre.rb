require './item'


class Genre
  attr_accessor :name, :items
  attr_reader :id

  def initialize(name)
    @id = Random.rand(1..100)
    @name = name
    @items = []
  end

  def add_item(item)
    return if @items.include?(item)

    @items << item
    item.genre = self
  end

  def self.all
    ObjectSpace.each_object(self).to_a
  end
end