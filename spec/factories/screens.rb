FactoryBot.define do
    factory :screen do
      association :theater, factory: :theater
      sequence(:screen_number) { |n| n }
    end
  end