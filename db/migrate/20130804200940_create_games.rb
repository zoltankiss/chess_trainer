class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :original_game
      t.string :current_game
      t.integer :current_game_score

      t.timestamps
    end
  end
end
