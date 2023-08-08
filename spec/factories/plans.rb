FactoryBot.define do
  factory :plan do
    name { Faker::Lorem.word }

    trait :trail do
      name { 'Trail Plan' }
      max_reviews_per_month { 3 }
    end

    trait :basic do
      name { 'Basic Plan' }
      max_reviews_per_month { 20 }
    end

    trait :pro do
      name { 'Pro Plan' }
      max_reviews_per_month { 100 }
    end
  end
end
