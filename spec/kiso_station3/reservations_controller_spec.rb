# spec/controllers/reservations_controller_spec.rb
require 'rails_helper'

RSpec.describe ReservationsController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:movie) { create(:movie) }
    let(:screen) { create(:screen) }
    let(:schedule) { create(:schedule, movie_id: movie.id, screen_id: screen.id, date: Date.tomorrow) }
    let(:sheet) { create(:sheet) }
    let(:reservation_params) { { user_id: user.id, schedule_id: schedule.id, sheet_id: sheet.id, movie_id: movie.id} }

    it '予約作成時にメールが送信されること' do
      expect {
        post :create, params: { reservation: reservation_params }
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
