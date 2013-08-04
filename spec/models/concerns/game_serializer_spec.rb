require File.expand_path('../../../../app/models/concerns/game_serializer', __FILE__)

describe GameSerializer do
  describe '.serialize' do
    it { GameSerializer.serialize([['e4', 'e5'], ['Nc3', 'Nc6']]).should == 'e4,e5|Nc3,Nc6' }
  end

  describe '.de_serialize' do
    it { GameSerializer.de_serialize('e4,e5|Nc3,Nc6').should == [['e4', 'e5'], ['Nc3', 'Nc6']] }
  end

  describe 'serialization' do
    it { GameSerializer.de_serialize(GameSerializer.serialize([['e4', 'e5']])).should == [['e4', 'e5']] }
  end
end
