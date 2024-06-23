# frozen_string_literal: true

# Rankingモデル:映画のランキング情報
class Ranking < ApplicationRecord
  belongs_to :movie

  validates :movie_id, uniqueness: { scope: :rank_date }
end
