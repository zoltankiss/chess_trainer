class GameTracker
  def initialize(game)
    @score = 0
    @current_move_correct = false
    @remaining_moves = self.class.split_game_string(game.remove_newlines)
    @next_opponent_move = @remaining_moves[0][1]
  end

  class << self
    def serialize_moves(arr)
      arr.map { |k| k.join(',') }.join('|')
    end

    def de_serialize_moves(str)
      str.split('|').map { |k| k.split(',') }
    end

    def split_game_string(game_string)
      game_string.split(/\d+\./).map do |k|
        if k.blank?
          nil
        else
          k.split(' ')
        end
      end.compact
    end
  end

  def guess_next_move(move)
    if @remaining_moves[0][0] == move
      @score += 1
      @current_move_correct = true
    else
      @current_move_correct = false
    end
    @next_opponent_move = @remaining_moves[0][1]
    unless game_is_over?
      @remaining_moves = @remaining_moves[1..-1]
    end
  end

  def current_score
    @score
  end

  def correct_guess?
    @current_move_correct
  end

  def game_is_over?
    @remaining_moves.count == 0
  end

  def next_opponent_move
    @next_opponent_move
  end
end