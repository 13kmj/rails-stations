FactoryBot.define do
    factory :theater do
      sequence(:name) { |n| "TESTTHEATER-#{n}" }
      sequence(:address) { |n| "東京都新宿区" }
    end
  end