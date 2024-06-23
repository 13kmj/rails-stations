class ReservationMailer < ApplicationMailer
  default from: 'no-reply@example.com'

  def reservation_confirmation(reservation)
    @reservation = reservation
    @user = @reservation.user
    @theater = @reservation.schedule.screen.theater
    @movie = @reservation.schedule.movie
    @screen = @reservation.schedule.screen
    @schedule = @reservation.schedule

    mail(to: @user.email, subject: '予約完了のお知らせ')
  end
end
