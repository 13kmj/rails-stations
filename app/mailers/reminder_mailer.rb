class ReminderMailer < ApplicationMailer
  default from: 'no-reply@example.com'

  def reminder_email(reservation)
    @reservation = reservation
    @user = @reservation.user
    @theater = @reservation.schedule.screen.theater
    @movie = @reservation.schedule.movie
    @screen = @reservation.schedule.screen
    @schedule = @reservation.schedule

    mail(to: @user.email, subject: 'ご予約前日のお知らせ')
  end
end