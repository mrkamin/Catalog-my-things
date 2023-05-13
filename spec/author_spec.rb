require_relative '../classes/author'

describe 'Unit Tests for Author' do
  before :each do
    @author = Author.new('rafi', 'amin')
  end

  context 'initialize' do
    it 'should be creat an Author' do
      expect(@author).to be_instance_of Author
    end
  end

  context 'First name' do
    it 'should be "rafi"' do
      expect(@author.first_name).to eql 'rafi'
    end
  end

  context 'Last name of author' do
    it 'should be amin' do
      expect(@author.last_name).to eql 'amin'
    end
  end
end
