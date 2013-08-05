require File.expand_path('../../../../config/initializers/core_ext/string', __FILE__)
require File.expand_path('../../../../app/models/concerns/game_tracker', __FILE__)
require 'active_support/core_ext/object/blank'

describe GameTracker do
  describe '#split_game_string' do
    it do
      GameTracker.split_game_string('1. e4 e6 2. d4 d5 3. Nc3 Bb4').should == [
        ['e4', 'e6'],
        ['d4', 'd5'],
        ['Nc3', 'Bb4'],
      ]
    end
  end

  context 'move serialization' do
    describe '.serialize_moves' do
      it { GameTracker.serialize_moves([['e4', 'e5'], ['Nc3', 'Nc6']]).should == 'e4,e5|Nc3,Nc6' }
    end

    describe '.de_serialize_moves' do
      it { GameTracker.de_serialize_moves('e4,e5|Nc3,Nc6').should == [['e4', 'e5'], ['Nc3', 'Nc6']] }
    end

    describe 'serialization' do
      it { GameTracker.de_serialize_moves(GameTracker.serialize_moves([['e4', 'e5']])).should == [['e4', 'e5']] }
    end
  end

  describe '#serialize' do
    it do
      game_instance = GameTracker.new("1. e4 e6 2. d4 d5 3. Nc3 Bb4")
      game_instance.guess_next_move('e4')
      game_instance.serialize.should == {
        original_game:         'e4,e6|d4,d5|Nc3,Bb4',
        current_game_score:    1,
        last_move:             'e4',
        current_move:          2,
      }
    end
  end

  describe '#load_serialization' do
    before(:all) do
      @game_instance = GameTracker.load_serialization({
        original_game:         'e4,e6|d4,d5|Nc3,Bb4',
        current_game_score:    1,
        last_move:             'e4',
        current_move:          2
      })
    end
    it { @game_instance.next_opponent_move.should == 'd5' }
    it { @game_instance.last_move_correct?.should be_true }
    it { @game_instance.last_actual_move.should == 'e4' }
    describe 'second move' do
      context 'wrong' do
        before(:all) { @game_instance.guess_next_move('e4') }
        it { @game_instance.correct_guess?.should     == false }
        it { @game_instance.next_opponent_move.should == 'd5' }
        it { @game_instance.current_score.should      == 1 }
        it { @game_instance.game_is_over?.should      == false }
        it { @game_instance.last_move_correct?.should be_false }
        it { @game_instance.last_actual_move.should == 'd4' }
      end
      describe 'third move' do
        context 'correct' do
          before(:all) { @game_instance.guess_next_move('Nc3') }
          it { @game_instance.correct_guess?.should     == true }
          it { @game_instance.next_opponent_move.should == 'Bb4' }
          it { @game_instance.current_score.should      == 2 }
          it { @game_instance.game_is_over?.should      == true }
          it { @game_instance.last_move_correct?.should be_true }
          it { @game_instance.last_actual_move.should == 'Nc3' }
        end
      end
    end
  end

  describe 'basic behavior' do
    before(:all) do
      @game_instance = GameTracker.new("1. e4 e6 2. d4 d5 3. Nc3 Bb4")
    end
    it { @game_instance.correct_guess?.should     == false }
    it { @game_instance.next_opponent_move.should be_nil }
    it { @game_instance.current_score.should      == 0 }
    it { @game_instance.game_is_over?.should      == false }
    it { @game_instance.last_move_correct?.should be_true }
    it { @game_instance.last_actual_move.should be_nil }
    describe 'first move' do
      context 'correct' do
        before(:all) { @game_instance.guess_next_move('e4') }
        it { @game_instance.correct_guess?.should     == true }
        it { @game_instance.next_opponent_move.should == 'e6' }
        it { @game_instance.current_score.should      == 1 }
        it { @game_instance.game_is_over?.should      == false }
        it { @game_instance.last_move_correct?.should be_true }
        it { @game_instance.last_actual_move.should == 'e4' }
        describe 'second move' do
          context 'wrong' do
            before(:all) { @game_instance.guess_next_move('e4') }
            it { @game_instance.correct_guess?.should     == false }
            it { @game_instance.next_opponent_move.should == 'd5' }
            it { @game_instance.current_score.should      == 1 }
            it { @game_instance.game_is_over?.should      == false }
            it { @game_instance.last_move_correct?.should be_false }
            it { @game_instance.last_actual_move.should == 'd4' }
          end
          describe 'third move' do
            context 'correct' do
              before(:all) { @game_instance.guess_next_move('Nc3') }
              it { @game_instance.correct_guess?.should     == true }
              it { @game_instance.next_opponent_move.should == 'Bb4' }
              it { @game_instance.current_score.should      == 2 }
              it { @game_instance.game_is_over?.should      == true }
              it { @game_instance.last_move_correct?.should be_true }
              it { @game_instance.last_actual_move.should == 'Nc3' }
            end
          end
        end
      end
    end
  end
end