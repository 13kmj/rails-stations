FactoryBot.define do
  factory :reservation do
    association :schedule, factory: :schedule
    association :sheet, factory: :sheet
  end
end
