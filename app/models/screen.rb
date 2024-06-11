# frozen_string_literal: true

# Screen モデル　各スクリーンのマスタデータ
class Screen < ApplicationRecord
  validates :screen_number, presence: true, uniqueness: { scope: %i[theater_id] }

  belongs_to :theater

  def screen_theater_name
    "#{theater.name}：#{screen_number}"
  end
end
