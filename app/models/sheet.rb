# frozen_string_literal: true

# Sheet モデル　座席のマスタデータ
class Sheet < ApplicationRecord
  # belongs_to :schedule, optional: true
  has_many :schedule

  def sheat_name
    "#{row} - #{column}"
  end
end
