# frozen_string_literal: true

# ランキング表示を処理するコントローラー
class WelcomeController < ApplicationController
  def index
    @rankings = Ranking.where(rank_date: Date.today).order(reservation_count: :desc)
  end
end
