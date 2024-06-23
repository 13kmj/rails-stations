# frozen_string_literal: true

# lib/tasks/update_rankings.rake
namespace :update do
  desc 'Update daily movie rankings'
  task daily_rankings: :environment do
    # 直近30日間に予約がある映画を取得
    movies_with_reservations = Movie.joins(schedules: :reservations)
                                    .where('reservations.created_at >= ?', 30.days.ago)
                                    .group('movies.id')
                                    .select('movies.id, COUNT(reservations.id) as reservation_count')

    # 現在の日付と時刻を取得
    current_time = Time.zone.now

    # ランキングテーブルに挿入するデータを準備
    rankings_data = movies_with_reservations.map do |movie|
      { movie_id: movie.id,
        reservation_count: movie.reservation_count,
        rank_date: Date.today,
        created_at: current_time,
        updated_at: current_time }
    end

    # ランキングテーブルに挿入
    Ranking.insert_all(rankings_data)
  end
end
