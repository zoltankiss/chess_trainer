
describe GameTracker do
  it 'basic behavior' do
    game = '1. e4 e6 2. d4 d5 3. Nc3 Bb4 0-1'

    game_instance = GameTracker.new(game)
    game_instance.current_score.should == 0

    game_instance.guess_next_move('e4')
    game_instance.correct_guess?.should == true
    game_instance.next_opponent_move.should == 'e6'
    game_instance.current_score.should == 1

    game_instance.guess_next_move('e4')
    game_instance.correct_guess?.should == false
    game_instance.next_opponent_move.should == 'd5'
    game_instance.current_score.should == 1

    game_instance.guess_next_move('Nc3')
    game_instance.correct_guess?.should == true
    game_instance.next_opponent_move.should == 'e6'
    game_instance.current_score.should == 2

    game_instance.guess_next_move('e4')
    game_instance.correct_guess?.should == true
    game_instance.next_opponent_move.should == 'e6'
    game_instance.current_score.should == 1
  end
end
