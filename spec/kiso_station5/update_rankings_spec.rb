# spec/tasks/update_rankings_spec.rb
require 'rails_helper'
require 'rake'

RSpec.describe 'update:daily_rankings' do
  let(:task_name) { 'update:daily_rankings' }

  before do
    Rake.application.rake_require('tasks/update_rankings')
    Rake::Task.define_task(:environment)
    Rake::Task[task_name].reenable
  end

  it '過去30日の予約数のランキングが作成できること' do
    # テストデータの準備
    user = create(:user)
    movie1 = create(:movie)
    movie2 = create(:movie)
    screen = create(:screen)
    schedule1 = create(:schedule, movie: movie1, screen: screen, date: Time.zone.tomorrow)
    schedule2 = create(:schedule, movie: movie2, screen: screen, date: Time.zone.tomorrow + 1.day)
    create_list(:reservation, 3, schedule: schedule1, user: user, created_at: 5.days.ago)
    create_list(:reservation, 2, schedule: schedule2, user: user, created_at: 25.days.ago)

    expect {
      Rake::Task[task_name].invoke
    }.to change { Ranking.count }.by(2)

    ranking1 = Ranking.find_by(movie_id: movie1.id)
    ranking2 = Ranking.find_by(movie_id: movie2.id)

    expect(ranking1.reservation_count).to eq(3)
    expect(ranking2.reservation_count).to eq(2)
  end

  it '過去30日より前のデータがカウントされていないこと' do
    # テストデータの準備
    user = create(:user)
    movie1 = create(:movie)
    movie2 = create(:movie)
    screen = create(:screen)
    schedule1 = create(:schedule, movie: movie1, screen: screen, date: Time.zone.tomorrow)
    schedule2 = create(:schedule, movie: movie2, screen: screen, date: Time.zone.tomorrow + 1.day)
    create_list(:reservation, 3, schedule: schedule1, user: user, created_at: 29.days.ago)
    create_list(:reservation, 2, schedule: schedule2, user: user, created_at: 30.days.ago)

    expect {
      Rake::Task[task_name].invoke
    }.to change { Ranking.count }.by(1)
  end
end
