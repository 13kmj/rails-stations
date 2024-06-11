# frozen_string_literal: true

# Theaterモデル:劇場情報
class Theater < ApplicationRecord
    has_many :screens
    has_many :movies, through: :screens
end
