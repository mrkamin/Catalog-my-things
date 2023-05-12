require_relative '../Classes/author'

describe 'Author' do
  before :each do
    @author = Author.new 'Milton', 'Henschel'
  end
  context 'Testing the author and its methods' do
    describe '#new' do
      it 'takes three parameters and returns a Student object' do
        expect(@author).to be_an_instance_of Author
      end
    end
    describe '#first_name' do
      it 'returns the first name' do
        expect(@author.first_name).to eq('Milton')
      end
    end
    describe '#last_name' do
      it 'returns the last name' do
        expect(@author.last_name).to eq('Henschel')
      end
    end
  end
end
