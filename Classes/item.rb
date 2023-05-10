require 'date'

class Item
  attr_accessor :publish_date, :archived
  attr_reader :id

  def initialize(publish_date)
    @id = rand(1..1000)
    @publish_date = publish_date
    @archived = false
  end

  def move_to_archive
    @archived = can_be_archived?
  end

  private

  def can_be_archived?
    Date.today - Date.parse(@publish_date) > 10 * 365
  end
end
