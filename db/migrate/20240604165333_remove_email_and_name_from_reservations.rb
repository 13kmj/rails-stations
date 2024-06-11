class RemoveEmailAndNameFromReservations < ActiveRecord::Migration[6.1]
  def change
    remove_column :reservations, :email, :string
    remove_column :reservations, :name, :string
  end
end
