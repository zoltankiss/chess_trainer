class GamesController < ApplicationController
  def new
  end

  def create
    @game = GameTracker.new(params[:moves])
    @game_model_instance = Game.create(@game.serialize)
    render 'game'
  end

  def edit
    get_game
    render 'game'
  end

  def guess_next_move
    get_game
    @game.guess_next_move(params[:move])
    @game_model_instance.update_attributes(@game.serialize)
    render 'game'
  end

  private
    def get_game
      @game_model_instance = Game.find(params[:id])
      @game = GameTracker.load_serialization({
        original_game:      @game_model_instance.original_game,
        current_game:       @game_model_instance.current_game,
        current_game_score: @game_model_instance.current_game_score
      })
    end
end