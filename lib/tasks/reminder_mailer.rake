# frozen_string_literal: true

# lib/tasks/reminder_mailer.rake
namespace :reminder_mailer do
  desc 'Send reminder emails for reservations happening tomorrow'
  task send_reminders: :environment do
    Reservation.joins(:schedule).where(schedules: { date: Time.zone.tomorrow }).find_each do |reservation|
      ReminderMailer.reminder_email(reservation).deliver_now
    end
  end
end
