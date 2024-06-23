class UpdateSchedules < ActiveRecord::Migration[6.1]
  def change
    # dateカラムの追加
    add_column :schedules, :date, :date

    # start_timeおよびend_timeの型変更
    change_column :schedules, :start_time, :time
    change_column :schedules, :end_time, :time

    # screenテーブルを参照するための外部キーの追加
    add_reference :schedules, :screen, foreign_key: true
  end
end
