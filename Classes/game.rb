require './item'

class Game < Item
  attr_accessor :multiplayer, :last_played_at, :publish_date

  def initialize(label, publish_date, multiplayer, last_played_at)
    super(label, publish_date)
    @multiplayer = multiplayer
    @last_played_at = last_played_at
  end

  private

  def can_be_archived?
    present_date = Time.now.year
    Item.can_be_archived? && present_date - last_played_at > 2
  end
end
