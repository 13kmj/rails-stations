# frozen_string_literal: true

# Movieモデル:映画情報
class Movie < ApplicationRecord
  validates :name, presence: true, uniqueness: { scope: %i[screen_id] }
  validates :year, presence: true
  validates :description, presence: true
  validates :image_url, presence: true
  validates :is_showing, presence: true
  validates :screen_id, presence: true

  has_many :schedules, dependent: :destroy
  belongs_to :screen
  has_one :theater, through: :screen
end
