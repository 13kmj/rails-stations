# frozen_string_literal: true

# Reservation モデル　映画の予約に使用
class Reservation < ApplicationRecord
  belongs_to :schedule
  has_one :movie, through: :schedule
  belongs_to :sheet
  belongs_to :user
  belongs_to :screen

  def screen_theater_name
    "#{theater.name}：#{screen_number}"
  end

  # validates :sheet_id, uniqueness: { scope: [:date, :schedule_id], message: "その座席はすでに予約済みです" }
  # validate :validate_unique_reservation
  # validates :date, uniqueness: { scope: %i[schedule_id sheet_id date screen_id] }

  # def validate_unique_reservation
  #  return if self.persisted? && !schedule_id_changed? && !sheet_id_changed?
  #  existing_reservation = Reservation.where(schedule_id: schedule_id, sheet_id: sheet_id).exists?
  #  errors.add(:base, "同じスケジュールに対する重複した予約が存在します。") if existing_reservation
  # end
end
