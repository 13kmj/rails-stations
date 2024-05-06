# frozen_string_literal: true

# Sheet モデル　各スクリーンの座席マスタ
class Sheet < ApplicationRecord
  belongs_to :schedule, optional: true
end
