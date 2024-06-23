require 'rails_helper'

# 映画予約周りのテスト
RSpec.describe Reservation, type: :model do
  let(:user) { create(:user) }
  let(:theater) { create(:theater) }
  let(:movie) { create(:movie) }
  let(:sheet) { create(:sheet) }
  let(:screen) { create(:screen) }
  let(:schedule) { create(:schedule, movie_id: movie.id, screen_id: screen.id, date: Date.tomorrow) }

  describe 'Staton15 Are date&schedule_id&screen_id&sheet_id unique?' do
    it '重複しない予約ができること' do
      reservation = Reservation.new(schedule_id: schedule.id, sheet_id: sheet.id, user_id: user.id)
      expect(reservation).to be_valid
    end

    it '同じ日付、スケジュール、座席、で予約ができないこと' do
      reservation = Reservation.new(schedule_id: schedule.id, sheet_id: sheet.id, user_id: user.id)
      duplicate_reservation = Reservation.new(schedule_id: schedule.id, sheet_id: sheet.id)
      expect(duplicate_reservation).not_to be_valid
    end
  end
end