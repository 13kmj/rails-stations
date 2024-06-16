# frozen_string_literal: true

# Reservation モデル　映画の予約に使用
class Reservation < ApplicationRecord
  belongs_to :schedule
  has_one :movie, through: :schedule
  belongs_to :sheet
  belongs_to :user

  def screen_theater_name
    "#{theater.name}：#{screen_number}"
  end
end
