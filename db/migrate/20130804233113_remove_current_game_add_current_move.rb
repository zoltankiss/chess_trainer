class RemoveCurrentGameAddCurrentMove < ActiveRecord::Migration
  def change
    remove_column :games, :current_game
    add_column    :games, :current_move, :integer
  end
end
