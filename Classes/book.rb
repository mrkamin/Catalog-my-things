require_relative './item'

class Book < Item
  attr_accessor :cover_state, :publisher

  def initialize(publish_date, cover_state, publisher)
    super(publish_date)
    @cover_state = cover_state
    @publisher = publisher
  end

  def as_hash
    {
      'id' => @id,
      'label' => @label.nil? ? '' : @label.as_hash,
      'source' => @source.nil? ? '' : @source.as_hash,
      'publish_date' => @publish_date,
      'archived' => @archived,
      'cover_state' => @cover_state,
      'publisher' => @publisher
    }
  end

  def can_be_archived?
    super || @cover_state == 'bad'
  end
end
