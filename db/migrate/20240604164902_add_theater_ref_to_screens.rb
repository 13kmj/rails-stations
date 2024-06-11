class AddTheaterRefToScreens < ActiveRecord::Migration[6.1]
  def change
    unless column_exists?(:screens, :theater_id)
      add_reference :screens, :theater, null: false, foreign_key: true
    end
  end
end