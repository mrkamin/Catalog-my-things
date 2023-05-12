class Label
  attr_accessor :title
  attr_reader :items

  def initialize(title)
    @id = rand(1..1000)
    @title = title
    @items = []
  end

  def add_item(item)
    if item.is_a?(Item) && !@items.include?(item)
      @items << item
      item.label = self
    end
  end

  def as_hash
    {
      'title' => @title
    }
  end
end
