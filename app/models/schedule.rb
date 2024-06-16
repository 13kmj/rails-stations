# frozen_string_literal: true

# Schedule モデル　上映スケジュールに使用
class Schedule < ApplicationRecord
  belongs_to :movie
  belongs_to :screen
  has_many :reservations, dependent: :destroy

  def schedule_information
    "【#{movie.name}】#{screen.theater.name}：スクリーン#{screen.screen_number}　#{date} #{start_time.strftime("%H:%M")} ~"
  end
end
