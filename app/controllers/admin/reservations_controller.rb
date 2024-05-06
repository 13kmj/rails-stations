# frozen_string_literal: true

module Admin
  # 映画予約に関するリクエストを処理するコントローラー(admin用)
  class ReservationsController < ApplicationController
    before_action :set_reservation, only: %i[show edit update destroy]

    def index
      @reservations = Reservation.includes(:movie, :schedule)
                                 .where('schedules.end_time > ?', Time.now)
                                 .references(:schedules)
    end

    def new
      @reservation_new = Reservation.new
      @sheets = Sheet.all
      @movies = Movie.all
      @schedules = Schedule.all
      @users = User.all
      @screens = Screen.all
    end

    def create
      @reservation = Reservation.new(reservation_params)
      @reservation_sheet = Reservation.find_by(date: reservation_params[:date],
                                               sheet_id: reservation_params[:sheet_id],
                                               schedule_id: reservation_params[:schedule_id],
                                               screen_id: reservation_params[:screen_id])
      return redirect_existing_reservation if @reservation_sheet

      save_reservation_or_render_new
    end

    def show
      @reservation = Reservation.find(params[:id])
      @movies = Movie.all
      @schedules = Schedule.all
      @screens = Screen.all
      @sheets = Sheet.all
      @users = User.all
    end

    def update
      @reservation = Reservation.find(params[:id])
      update_reservation
    end

    def destroy
      @reservation.destroy
      redirect_to admin_reservations_path, notice: '予約が削除されました。'
    end

    private

    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    def reservation_params
      params.require(:reservation).permit(:date, :sheet_id, :schedule_id, :email, :name, :screen_id, :user_id)
    end

    def redirect_existing_reservation
      return unless @reservation_sheet

      flash[:error] = '既に予約されています'

      redirect_to admin_reservations_path(params[:reservation][:movie_id],
                                          date: reservation_params[:date],
                                          schedule_id: reservation_params[:schedule_id],
                                          screen_id: reservation_params[:screen_id]), status: :found
    end

    def save_reservation_or_render_new
      if @reservation.save
        flash[:success] = '予約が完了しました'
        redirect_to admin_reservations_path
      else
        render :new
      end
    end

    def check_reservation
      # 重複予約のチェック
      Reservation.where(date: reservation_params[:date],
                        schedule_id: reservation_params[:schedule_id],
                        sheet_id: reservation_params[:sheet_id],
                        screen_id: reservation_params[:screen_id])
                 .where.not(id: @reservation.id) # 現在の予約を除外
                 .exists?
    end

    def update_reservation
      if check_reservation
        flash[:alert] = 'その座席はすでに予約済みです'
        redirect_to admin_reservations_path, status: :found
        return
      end

      if @reservation.update(reservation_params)
        redirect_to admin_reservations_path, notice: '予約が正常に更新されました。'
      else
        render :edit, status: :bad_request
      end
    end
  end
end
