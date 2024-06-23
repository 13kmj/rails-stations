class CreateRankings < ActiveRecord::Migration[6.1]
  def change
    create_table :rankings do |t|
      t.references :movie, null: false, foreign_key: true
      t.integer :reservation_count
      t.date :rank_date

      t.timestamps
    end

    add_index :rankings, [:movie_id, :rank_date], unique: true
  end
end
