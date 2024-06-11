class CreateTheater < ActiveRecord::Migration[6.1]
  def change
    create_table :theaters do |t|
      t.string 'name', limit: 160, null: false, index: true, comment: '劇場名'
      t.string 'address', limit: 160, null: false, index: true, comment: '劇場の住所'
      t.timestamps
    end
  end
end
