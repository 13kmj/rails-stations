# spec/mailers/reminder_mailer_spec.rb
require 'rails_helper'

RSpec.describe ReminderMailer, type: :mailer do
  describe 'reminder_email' do
    let(:user) { create(:user, email: 'test@example.com') }
    let(:movie) { create(:movie) }
    let(:screen) { create(:screen) }
    let(:schedule) { create(:schedule, movie: movie, screen: screen, date: Time.zone.tomorrow) }
    let(:reservation) { create(:reservation, user: user, schedule: schedule) }
    let(:mail) { ReminderMailer.reminder_email(reservation) }

    it 'ヘッダーの内容がテンプレートに沿っていること' do
      expect(mail.subject).to eq('ご予約前日のお知らせ')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['no-reply@example.com'])
    end

    it '本文の内容がテンプレートに沿っていること' do
      expect(mail.body.encoded).to match("#{user.name}様")
      expect(mail.body.encoded).to match("予約前日となりました。")
    end
  end
end
