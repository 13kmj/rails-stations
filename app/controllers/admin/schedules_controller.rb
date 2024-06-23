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
      start_date = Date.parse(schedule_create_params[:start_date])
      end_date = Date.parse(schedule_create_params[:end_date])
      days_of_week = schedule_create_params[:days_of_week].map(&:to_i)

      schedules = []

      if start_date > end_date
        flash[:alert] = '終了日は開始日より後の日付にしてください。'
        render :new and return
      end

      # 指定した期間、曜日に当てはまる日付でレコードを作成
      (start_date..end_date).each do |date|
        next unless days_of_week.include?(date.wday)

        schedules << Schedule.new(
          movie_id: schedule_create_params[:movie_id],
          screen_id: schedule_create_params[:screen_id],
          date: date,
          start_time: schedule_create_params[:start_time],
          end_time: schedule_create_params[:end_time]
        )
      end

      if schedules.all?(&:valid?)
        schedules.each(&:save!)
        redirect_to admin_schedules_path, notice: 'スケジュールが作成されました'
      else
        error_messages = schedules.map { |s| s.errors.full_messages }.flatten.uniq
        flash[:alert] = "スケジュールの作成に失敗しました: #{error_messages.join(', ')}"
        render :new
      end
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

    private

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
