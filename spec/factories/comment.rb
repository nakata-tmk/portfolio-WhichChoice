FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.characters(number: 30) }
    user
    question
  end
end