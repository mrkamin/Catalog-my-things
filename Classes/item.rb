require 'date'

class Item
  attr_accessor :publish_date, :archived, :label
  attr_reader :id, :genre, :author, :source

  def initialize(publish_date)
    @id = rand(1..1000)
    @publish_date = publish_date
    @archived = false
  end

  def genre=(genre)
    @genre = genre
    genre.items << self unless genre.items.include?(self)
  end

  def author=(author)
    @author = author
    author.items << self unless author.items.include?(self)
  end

  def source=(source)
    @source = source
    source.items << self unless source.items.include?(self)
  end

  def label=(label)
    if label.is_a?(Label)
      @label = label
      label.items << self unless label.items.include?(self)
    end
  end

  def move_to_archive
    @archived = can_be_archived?
  end

  private

  def can_be_archived?
    begin
      parsed_date = DateTime.strptime(@publish_date, '%m/%d/%Y')
      Date.today - parsed_date.to_date > 10 * 365
    rescue ArgumentError
      false
    end
  end
end
