require_relative './item'

class Music < Item
  attr_accessor :name, :on_spotify

  def initialize(publish_date, name, on_spotify)
    super(publish_date)
    @name = name
    @on_spotify = on_spotify
  end

  def as_hash
    {
      'id' => @id,
      'publish_date' => @publish_date,
      'name' => @name,
      'archived' => @archived,
      'on_spotify' => @on_spotify
    }
  end

  def can_be_archived?
    super && on_spotify
  end
end
