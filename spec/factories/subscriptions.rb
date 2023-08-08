FactoryBot.define do
  factory :subscription do
    association :user
    association :plan
  end

  trait :without_user do
    user { nil }
  end

  trait :without_plan do
    plan { nil }
  end
end
