# frozen_string_literal: true

module Admin
  # 上映スケジュールに関するリクエストを処理するコントローラー(admin用)
  class SchedulesController < ApplicationController
    def index
      @movies = Movie.includes(:schedules).where.not(schedules: { id: nil })
    end

    def show
      @schedule = Schedule.find(params[:id])
    end

    def create
      start_date, end_date, days_of_week = parse_dates_and_days

      return if dates_invalid?(start_date, end_date)

      schedules = build_schedules(start_date, end_date, days_of_week)

      if schedules.all?(&:valid?)
        save_schedules_and_redirect(schedules)
      else
        handle_schedule_errors(schedules)
      end
    end

    private

    def dates_invalid?(start_date, end_date)
      if start_date > end_date
        render_with_flash('終了日は開始日より後の日付にしてください。')
        true
      else
        false
      end
    end

    def parse_dates_and_days
      start_date = Date.parse(schedule_create_params[:start_date])
      end_date = Date.parse(schedule_create_params[:end_date])
      days_of_week = schedule_create_params[:days_of_week].map(&:to_i)
      [start_date, end_date, days_of_week]
    end

    def build_schedules(start_date, end_date, days_of_week)
      (start_date..end_date).each_with_object([]) do |date, schedules|
        next unless days_of_week.include?(date.wday)

        schedules << Schedule.new(
          movie_id: schedule_create_params[:movie_id],
          screen_id: schedule_create_params[:screen_id],
          date: date,
          start_time: schedule_create_params[:start_time],
          end_time: schedule_create_params[:end_time]
        )
      end
    end

    def save_schedules_and_redirect(schedules)
      schedules.each(&:save!)
      redirect_to admin_schedules_path, notice: 'スケジュールが作成されました'
    end

    def handle_schedule_errors(schedules)
      error_messages = schedules.map { |s| s.errors.full_messages }.flatten.uniq
      flash[:alert] = "スケジュールの作成に失敗しました: #{error_messages.join(', ')}"
      render :new
    end

    def render_with_flash(message)
      flash[:alert] = message
      render :new
    end

    def edit
      @schedule = Schedule.find(params[:id])
    end

    def update
      @schedule = Schedule.find(params[:id])
      if @schedule.update(schedule_params)
        redirect_to admin_schedule_path(@schedule), notice: '上映スケジュールを更新しました。'
      else
        flash[:alert] = @schedule.errors.full_messages.join(', ')
        render :edit
      end
    end

    def destroy
      @schedule = Schedule.find(params[:id])
      @schedule.destroy
      redirect_to admin_schedules_path, notice: 'スケジュールを削除しました。'
    end

    def schedule_params
      params.require(:schedule).permit(:start_time, :end_time, :date, :screen_id)
    end

    def schedule_create_params
      {
        movie_id: params[:movie_id],
        screen_id: params[:screen_id],
        start_date: params[:start_date],
        end_date: params[:end_date],
        start_time: params[:start_time],
        end_time: params[:end_time],
        days_of_week: params[:days_of_week]
      }
    end
  end
end
