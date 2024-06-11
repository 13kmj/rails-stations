# frozen_string_literal: true

# 映画に関するリクエストを処理するコントローラー
class MoviesController < ApplicationController
  def index
    @movies = Movie.all

    if params[:keyword].present?
      @movies = @movies.where('name LIKE ? OR description LIKE ?', "%#{params[:keyword]}%", "%#{params[:keyword]}%")
    end

    if params[:theater].present?
      theaters = Theater.where('address LIKE ? OR name LIKE ?', "%#{params[:theater]}%", "%#{params[:theater]}%")
      theater_ids = theaters.pluck(:id)
      screen_ids = Screen.where(theater_id: theater_ids).pluck(:id)
      @movies = @movies.where(screen_id: screen_ids)
    end
  end

  def show
    @movie = Movie.find(params[:id])
    @schedules = @movie.schedules
  end

  def reservation
    return unless load_movie_and_check_presence

    @schedule = Schedule.find_by(id: params[:schedule_id])
    @date = params[:date]
    @sheets = Sheet.order(:row, :column)

    set_reserved_sheet_ids

    return if params[:date].present? && params[:schedule_id].present?

    redirect_to movie_path(@movie), alert: '日付またはスケジュールIDのいずれかが必要です', status: :found
    nil
  end

  def load_movie_and_check_presence
    @movie = Movie.find_by(id: params[:id])
    return true if @movie

    redirect_to movie_path(@movie), alert: '指定された映画が見つかりません。'
    false
  end

  def set_reserved_sheet_ids
    @reserved_sheet_ids = Reservation.where(date: @date, schedule_id: @schedule.id, screen_id: @movie.screen_id)
                                     .pluck(:sheet_id)
  end
end
