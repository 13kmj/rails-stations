# spec/kiso_station4/reminder_mailer_task_spec.rb
require 'rails_helper'
require 'rake'

RSpec.describe 'reminder_mailer:send_reminders' do
  let(:task_name) { 'reminder_mailer:send_reminders' }

  before do
    Rake.application.rake_require('tasks/reminder_mailer')
    Rake::Task.define_task(:environment)
    Rake::Task[task_name].reenable
  end

  it '予約確認メールが送信されること' do
    user = create(:user, email: 'test@example.com')
    movie = create(:movie)
    screen = create(:screen)
    schedule = create(:schedule, movie: movie, screen: screen, date: Time.zone.tomorrow)
    reservation = create(:reservation, user: user, schedule: schedule)

    expect(ReminderMailer).to receive(:reminder_email).with(reservation).and_call_original
    expect {
      Rake::Task[task_name].invoke
    }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end
end
