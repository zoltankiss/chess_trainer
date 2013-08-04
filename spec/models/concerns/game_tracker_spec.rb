require File.expand_path('../../../../config/initializers/core_ext/string', __FILE__)
require File.expand_path('../../../../app/models/concerns/game_tracker', __FILE__)
require 'active_support/core_ext/object/blank'

describe GameTracker do
  describe '#split_game_string' do
    it do
      GameTracker.split_game_string('1. e4 e6 2. d4 d5 3. Nc3 Bb4 0-1').should == [
        ['e4', 'e6'],
        ['d4', 'd5'],
        ['Nc3', 'Bb4'],
      ]
    end
  end

  describe 'basic behavior' do
    before(:all) do
      @game_instance = GameTracker.new("1. e4 e6 2. d4 d5 3. Nc3 Bb4 0-1")
    end
    it { @game_instance.correct_guess?.should     == false }
    it { @game_instance.next_opponent_move.should == 'e6' }
    it { @game_instance.current_score.should      == 0 }
    it { @game_instance.game_is_over?.should      == false }
    describe 'first move' do
      context 'correct' do
        before(:all) { @game_instance.guess_next_move('e4') }
        it { @game_instance.correct_guess?.should     == true }
        it { @game_instance.next_opponent_move.should == 'e6' }
        it { @game_instance.current_score.should      == 1 }
        it { @game_instance.game_is_over?.should      == false }
        describe 'second move' do
          context 'wrong' do
            before(:all) { @game_instance.guess_next_move('e4') }
            it { @game_instance.correct_guess?.should     == false }
            it { @game_instance.next_opponent_move.should == 'd5' }
            it { @game_instance.current_score.should      == 1 }
            it { @game_instance.game_is_over?.should      == false }
          end
          describe 'third move' do
            context 'correct' do
              before(:all) { @game_instance.guess_next_move('Nc3') }
              it { @game_instance.correct_guess?.should     == true }
              it { @game_instance.next_opponent_move.should == 'Bb4' }
              it { @game_instance.current_score.should      == 2 }
              it { @game_instance.game_is_over?.should      == true }
            end
          end
        end
      end
    end
  end
end