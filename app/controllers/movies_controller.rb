# frozen_string_literal: true

# 映画に関するリクエストを処理するコントローラー
class MoviesController < ApplicationController
  def index
    @movies = Movie.all

    if params[:keyword].present?
      @movies = @movies.where('name LIKE ? OR description LIKE ?', "%#{params[:keyword]}%", "%#{params[:keyword]}%")
    end

    return unless params[:is_showing].present?

    @movies = @movies.where(is_showing: params[:is_showing] == '1')
  end

  def show
    return unless load_movie_and_check_presence

    @movie = Movie.find(params[:id])
    @schedules = @movie.schedules
  end

  def reservation
    return unless load_movie_and_check_presence
    return unless check_schedule_id

    # @schedule = Schedule.find_by(id: params[:schedule_id])
    @sheets = Sheet.order(:row, :column)

    set_reserved_sheet_ids
  end

  def load_movie_and_check_presence
    @movie = Movie.find_by(id: params[:id])
    return true if @movie

    redirect_to movies_path, alert: '指定された映画が見つかりません。'
    false
  end

  def check_schedule_id
    @schedule = Schedule.find_by(id: params[:schedule_id])
    return true if @schedule

    redirect_to movie_path(@movie), alert: 'スケジュールIDが必要です', status: :found
    false
  end

  def set_reserved_sheet_ids
    @reserved_sheet_ids = Reservation.where(schedule_id: @schedule.id)
                                     .pluck(:sheet_id)
  end
end
