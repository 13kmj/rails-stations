# frozen_string_literal: true

# シートに関するリクエストを処理するコントローラー
class SheetsController < ApplicationController
  def index
    @sheets = Sheet.all.order(:row, :column)
  end
end
