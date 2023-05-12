require_relative '../Classes/game'
require_relative '../Classes/book'

describe 'Game' do
  before :each do
    @game = Game.new '2013', true, '2020'
  end
  context 'Testing the game and its methods' do
    describe '#new' do
      it 'takes three parameters and returns a Game object' do
        expect(@game).to be_an_instance_of Game
      end
    end
    describe '#publish_date' do
      it 'returns the publish date' do
        expect(@game.publish_date).to eq('2013')
      end
    end
    describe '#multiplayer' do
      it 'returns the multiplayer' do
        expect(@game.multiplayer).to eq(true)
      end
    end
    describe '#last_played_at' do
      it 'returns the last played year' do
        expect(@game.last_played_at).to eq('2020')
      end
    end
    describe '#can_be_archived?' do
      it 'returns true when last played date is older than two years' do
        book = Book.new '01/01/2013', '', ''
        expect(book.can_be_archived?).to eq(true)
      end
    end
  end
end
