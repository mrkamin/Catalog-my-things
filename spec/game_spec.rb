require_relative '../classes/game'

describe 'Unit Tests for Game' do
  before :each do
    @game = Game.new('1990/08/20', '2009/05/02', 'No')
  end

  context 'initialize object' do
    it 'should be a Game instance' do
      expect(@game).to be_instance_of Game
    end

    it 'should not be an Item instance' do
      expect(@game).not_to be_instance_of Item
    end

    it 'should be an Item instace' do
      expect(@game).to be_kind_of Item
    end
  end

  context 'when was game last played' do
    it 'should be "2009/05/02"' do
      expect(@game.last_played).to eql '2009/05/02'
    end

    context 'when was game published' do
      it 'should be "1990/08/20"' do
        expect(@game.publish_date).to eql '1990/08/20'
      end
    end
    context 'Multiplayer Game' do
      it 'should be "No"' do
        expect(@game.multiplayer).to eql 'No'
      end
    end
  end
end
