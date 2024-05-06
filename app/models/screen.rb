# frozen_string_literal: true

# Screen モデル　各スクリーンマスタ
class Screen < ApplicationRecord
  validates :screen_number, presence: true
end
