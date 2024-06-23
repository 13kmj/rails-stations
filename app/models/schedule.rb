# frozen_string_literal: true

# Schedule モデル　上映スケジュールに使用
class Schedule < ApplicationRecord
  belongs_to :movie
  belongs_to :screen
  has_many :reservations, dependent: :destroy

  validate :no_time_overlap
  validate :start_date_in_future
  validate :start_time_before_end_time

  def schedule_information
    "【#{movie.name}】#{screen.theater.name}：スクリーン#{screen.screen_number}　#{date} #{start_time.strftime('%H:%M')} ~"
  end

  private

  def no_time_overlap
    overlapping_schedules = Schedule.where(screen_id: screen_id, date: date)
                                    .where.not(id: id)
                                    .where('start_time < ? AND end_time > ?', end_time, start_time)
    errors.add(:base, '指定した時間帯は既に予約されています。') if overlapping_schedules.exists?
  end

  def start_date_in_future
    errors.add(:base, '明日以降の日付を指定してください。') if date < Date.today
  end

  def start_time_before_end_time
    errors.add(:base, '開始時刻は終了時刻より前でなければなりません。') if start_time >= end_time
  end
end
