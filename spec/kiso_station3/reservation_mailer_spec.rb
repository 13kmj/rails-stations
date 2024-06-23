# spec/mailers/reservation_mailer_spec.rb
require 'rails_helper'

RSpec.describe ReservationMailer, type: :mailer do
  describe 'reservation_confirmation' do
    let(:user) { create(:user, email: 'test@example.com', name: 'Test User') }
    let(:movie) { create(:movie) }
    let(:screen) { create(:screen) }
    let(:schedule) { create(:schedule, movie_id: movie.id, screen_id: screen.id, date: Date.tomorrow) }
    let(:sheet) { create(:sheet) }
    let(:reservation) { create(:reservation, user_id: user.id, schedule_id: schedule.id, sheet_id: sheet.id) }
    let(:mail) { ReservationMailer.reservation_confirmation(reservation) }

    it 'ヘッダーの内容がテンプレートに沿っていること' do
      expect(mail.subject).to eq('予約完了のお知らせ')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['no-reply@example.com'])
    end

    it '本文の内容がテンプレートに沿っていること' do
      expect(mail.body.encoded).to match("Test User様")
      expect(mail.body.encoded).to match("予約が完了しました。")
    end
  end
end
