# app/controllers/welcome_controller.rb
class WelcomeController < ApplicationController
  def index
    @rankings = Ranking.where(rank_date: Date.today).order(reservation_count: :desc)
  end
end
