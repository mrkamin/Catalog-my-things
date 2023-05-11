require_relative './item'

class Game < Item
  attr_accessor :multiplayer, :last_played_at, :publish_date

  def initialize(publish_date, multiplayer, last_played_at)
    super(publish_date)
    @multiplayer = multiplayer
    @last_played_at = last_played_at
  end

  def as_hash
    {
      'id' => @id,
      'multiplayer' => @multiplayer,
      'last_played_at' => @last_played_at,
      'publish_date' => @publish_date
    }
  end

  private

  def can_be_archived?
    present_date = Time.now.year
    super && present_date - last_played_at > 2
  end
end
