FactoryBot.define do
  factory :review do
    content { Faker::Lorem.paragraph }
    review_date { DateTime.now }
    association :user
  end

  trait :with_custom_content do
    content { "Custom review content" }
  end
end
