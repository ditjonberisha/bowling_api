class CreateFrames < ActiveRecord::Migration[5.2]
  def change
    create_table :frames do |t|
      t.belongs_to :game, foreign_key: true
      t.integer :number
      t.integer :first_ball
      t.integer :second_ball
      t.integer :third_ball
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
