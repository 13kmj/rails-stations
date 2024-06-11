require 'rails_helper'

# 映画予約周りのテスト
RSpec.describe Reservation, type: :model do
  let(:user) { create(:user) }
  let(:theater) { create(:theater) }
  let(:screen) { create(:screen, theater_id: theater.id) }
  let(:movie) { create(:movie, screen_id: screen.id) }
  let(:sheet) { create(:sheet) }
  let(:schedule) { create(:schedule, movie_id: movie.id) }

  describe 'Staton15 Are date&schedule_id&screen_id&sheet_id unique?' do
    it '重複しない予約ができること' do
      reservation = Reservation.new(schedule_id: schedule.id, sheet_id: sheet.id, screen_id: screen.id, user_id: user.id)
      expect(reservation).to be_valid
    end

    it '同じ日付、スケジュール、劇場(スクリーン)、座席、で予約ができないこと' do
      reservation = Reservation.new(schedule_id: schedule.id, sheet_id: sheet.id, screen_id: screen.id, user_id: user.id)
      duplicate_reservation = Reservation.new(schedule_id: schedule.id, sheet_id: sheet.id, screen_id: screen.id, date: reservation.date)
      expect(duplicate_reservation).not_to be_valid
    end
  end
end