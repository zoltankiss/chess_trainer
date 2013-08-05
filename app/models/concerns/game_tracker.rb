class GameTracker
  attr_accessor :score,
                :current_move_correct,
                :original_moves,
                :remaining_moves,
                :next_opponent_move,
                :last_move,
                :last_actual_move,
                :current_move

  def initialize(game = nil)
    unless game.nil?
      @score = 0
      @current_move_correct = false
      @original_moves = @remaining_moves = self.class.split_game_string(game.remove_newlines)
      @next_opponent_move = @remaining_moves[0][1]
      @last_move = nil
      @last_actual_move = nil
      @current_move = 1
    end
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

    def load_serialization(serialization)
      instance                      = self.new
      instance.score                = serialization[:current_game_score]
      instance.current_move_correct = false
      instance.original_moves       = de_serialize_moves(serialization[:original_game])
      instance.remaining_moves      = instance.original_moves[(serialization[:current_move] - 1)..-1]
      instance.next_opponent_move   = instance.remaining_moves[0][1]
      instance.last_move            = serialization[:last_move]
      instance.last_actual_move     = serialization[:current_move] == 1 ? nil : instance.original_moves[serialization[:current_move] - 2][0]
      instance.current_move         = serialization[:current_move] || 1
      instance
    end
  end

  def serialize
    {
      original_game:         self.class.serialize_moves(@original_moves),
      current_game_score:    @score,
      last_move:             @last_move,
      current_move:          @current_move
    }
  end

  def guess_next_move(move)
    @current_move += 1
    @last_move = move
    @last_actual_move = @remaining_moves[0][0]
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
    if @original_moves.count == @remaining_moves.count
      nil
    else
      @next_opponent_move
    end
  end

  def last_move_correct?
    @last_actual_move == @last_move
  end

  def last_move
    @last_move
  end

  def last_actual_move
    @last_actual_move
  end

  def first_move
    @remaining_moves[0][0]
  end

  def current_move
    @original_moves.count - @remaining_moves.count
  end
end