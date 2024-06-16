class Ranking < ApplicationRecord
  belongs_to :movie

  validates :movie_id, uniqueness: { scope: :rank_date }
end
