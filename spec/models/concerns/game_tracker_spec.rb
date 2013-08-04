require File.expand_path('../../../../app/models/concerns/game_tracker', __FILE__)

describe GameTracker do
  describe 'basic behavior' do
    let(:game)          { '1. e4 e6 2. d4 d5 3. Nc3 Bb4 0-1' }
    let(:game_instance) { GameTracker.new(game) }

    it do
      game_instance.correct_guess?.should == false
      game_instance.next_opponent_move.should == 'e6'
      game_instance.current_score.should == 0
      game_instance.game_is_over?.should == false
    end

    describe 'first move' do
      context 'correct move' do
        before { game_instance.guess_next_move('e4') }
        it do
          game_instance.correct_guess?.should == true
          game_instance.next_opponent_move.should == 'e6'
          game_instance.current_score.should == 1
          game_instance.game_is_over?.should == false
        end
        describe 'second move' do
          context 'wrong move' do
            before { game_instance.guess_next_move('e4') }
            it do
              game_instance.correct_guess?.should == false
              game_instance.next_opponent_move.should == 'd5'
              game_instance.current_score.should == 1
              game_instance.game_is_over?.should == false
            end
          end
          describe 'third move' do
            context 'correct move' do
              before { game_instance.guess_next_move('e4') }
              it do
                game_instance.correct_guess?.should == true
                game_instance.next_opponent_move.should == 'Bb4'
                game_instance.current_score.should == 2
                game_instance.game_is_over?.should == true
              end
            end
          end
        end
      end
    end
  end
end
