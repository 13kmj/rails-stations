# frozen_string_literal: true

# Schedule モデル　上映スケジュールに使用
class Schedule < ApplicationRecord
  belongs_to :movie
  has_many :reservations
  has_many :sheets
end
