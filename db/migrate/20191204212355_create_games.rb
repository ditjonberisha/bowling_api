class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.string :name
      t.integer :total_score, default: 0
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
