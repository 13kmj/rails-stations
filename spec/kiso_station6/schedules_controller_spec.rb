# spec/controllers/schedules_controller_spec.rb
require 'rails_helper'

RSpec.describe Admin::SchedulesController, type: :controller do
  describe 'POST #create' do
    let(:movie) { create(:movie) }
    let(:screen) { create(:screen) }
    let(:schedule_create_params) do
      {
        start_date: (Date.today + 5.days).to_s,
        end_date: (Date.today + 7.days).to_s,
        days_of_week: [Date.today.wday],
        movie_id: movie.id,
        screen_id: screen.id,
        start_time: '10:00',
        end_time: '12:00'
      }
    end

    context 'when dates are valid' do
      it 'スケジュールが登録できること' do
        post :create, params: schedule_create_params
        expect(response).to redirect_to(admin_schedules_path)
        expect(flash[:notice]).to eq('スケジュールが作成されました')
      end
    end

    context 'when end_date is before start_date' do
      it '終了日が開始日より後の日付でないと登録ができないこと' do
        invalid_params = schedule_create_params.deep_dup
        invalid_params[:end_date] = (Date.today - 1.day).to_s
        post :create, params: invalid_params
        expect(response).to render_template(:new)
        expect(flash[:alert]).to eq('終了日は開始日より後の日付にしてください。')
      end
    end

    context 'when schedule has overlapping times' do
      before do
        create(:schedule, screen: screen, movie: movie, date: Date.today, start_time: '11:00', end_time: '13:00')
      end

      it '時間帯、劇場、スクリーンが重複しているスケジュールが登録できないこと' do
        invalid_params = schedule_create_params.deep_dup
        invalid_params[:start_date] = (Date.today).to_s
        invalid_params[:end_date] = (Date.today).to_s
        post :create, params: invalid_params
        expect(response).to render_template(:new)
        expect(flash[:alert]).to include('指定した時間帯は既に予約されています。')
      end
    end

    context 'when schedule date is in the past' do
      it '過去の日付でスケジュールが登録できないこと' do
        invalid_params = schedule_create_params.deep_dup
        invalid_params[:start_date] = (Date.today - 10.days).to_s
        invalid_params[:end_date] = (Date.today - 2.day).to_s
        post :create, params: invalid_params
        expect(response).to render_template(:new)
        expect(flash[:alert]).to include('明日以降の日付を指定してください。')
      end
    end

    context 'when start time is after end time' do
      it '終了時刻が開始時刻より後のでないと登録ができないこと' do
        invalid_params = schedule_create_params.deep_dup
        invalid_params[:start_time] = '14:00'
        invalid_params[:end_time] = '13:00'
        post :create, params: invalid_params
        expect(response).to render_template(:new)
        expect(flash[:alert]).to include('開始時刻は終了時刻より前でなければなりません。')
      end
    end
  end
end
