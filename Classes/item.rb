class Item
  attr_reader :id
  attr_accessor :genre, :author, :source, :label, :publish_date, :archived

  def initialize(genre, author, source, label, publish_date)
    @id = Random.rand(1..1000)
    @genre = genre
    @author = author
    @source = source
    @label = label
    @publish_date = publish_date
    @archived = []
  end

  def move_to_archive; end

  private

  def can_be_archived?
    present_date = Time.now
    present_date - publish_date > 10
  end
end
