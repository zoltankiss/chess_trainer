class AddLastMoveToGameModel < ActiveRecord::Migration
  def change
    add_column :games, :last_move, :string
  end
end
