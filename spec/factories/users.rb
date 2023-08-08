FactoryBot.define do
  factory :user do
    username { Faker::Name.name }
    email { Faker::Internet.email }
    password { '11223344' }
  end

	trait :with_duplicate_email do
    email { "test@example.com" }	
  end
end
