class RemoveScreenIdFromMovies < ActiveRecord::Migration[6.1]
  def change
    remove_column :movies, :screen_id, :bigint
  end
end
