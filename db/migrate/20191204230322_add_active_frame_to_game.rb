class AddActiveFrameToGame < ActiveRecord::Migration[5.2]
  def change
    add_reference :games, :active_frame, index: true, foreign_key: { to_table: :frames }
  end
end
