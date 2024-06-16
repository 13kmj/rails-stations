class RemoveDateAndScreenIdFromReservations < ActiveRecord::Migration[6.1]
  def change
    remove_column :reservations, :date, :date
    remove_column :reservations, :screen_id, :bigint
  end
end
