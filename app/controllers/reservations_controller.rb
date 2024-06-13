# frozen_string_literal: true

# 映画予約に関するリクエストを処理するコントローラー
class ReservationsController < ApplicationController
  before_action :login_check, only: [:new]

  def new
    @reservation = Reservation.new
    @movie = load_movie
    @date = params[:date]
    @screen = params[:screen_id]
    @schedule = Schedule.find_by(id: params[:schedule_id])
    @sheet = Sheet.find_by(id: params[:sheet_id])

    return if valid_parameters_present?

    redirect_to_movie_path_or_error
  end

  def create
    @reservation = Reservation.new(reservation_params)
    @reserved_sheet = find_reserved_sheet

    if @reserved_sheet
      redirect_to_reserved_sheet
    elsif @reservation.save
      redirect_to_reservation_success
    else
      handle_reservation_failure
    end
  end

  private

  def load_movie
    movie = Movie.find_by(id: params[:movie_id])
    if movie.nil?
      redirect_to movies_path, alert: '指定された映画が見つかりません。'
      return nil
    end
    movie
  end

  def reservation_params
    params.require(:reservation).permit(:date, :sheet_id, :schedule_id, :email, :name, :screen_id, :user_id)
  end

  def valid_parameters_present?
    params[:date].present? && params[:sheet_id].present?
  end

  def redirect_to_movie_path_or_error
    redirect_to movie_path(@movie), alert: '日付と座席IDの両方が必要です。', status: :found
  end

  def find_reserved_sheet
    Reservation.find_by(date: params[:reservation][:date],
                        schedule_id: params[:reservation][:schedule_id],
                        sheet_id: params[:reservation][:sheet_id],
                        screen_id: params[:reservation][:screen_id])
  end

  def redirect_to_reserved_sheet
    flash[:notice] = 'その座席はすでに予約済みです。'
    redirect_to reservation_movie_path(id: params[:reservation][:movie_id],
                                       schedule_id: params[:reservation][:schedule_id],
                                       date: params[:reservation][:date],
                                       sheet_id: params[:reservation][:sheet_id])
  end

  def redirect_to_reservation_success
    ReservationMailer.reservation_confirmation(@reservation).deliver_now
    flash[:success] = '予約が完了しました。詳細はメールをご確認ください。'
    redirect_to movie_path(params[:reservation][:movie_id])
  end

  def handle_reservation_failure
    flash[:alert] = '予約に失敗しました。'
    render :new
  end

  def login_check
    return if user_signed_in?

    redirect_to movies_path
    flash[:alert] = 'ログインをしてください'
  end
end
