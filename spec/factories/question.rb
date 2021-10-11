FactoryBot.define do
  factory :question do
    object1 { Faker::Lorem.characters(number: 10) }
    object2 { Faker::Lorem.characters(number: 10)}
    body { Faker::Lorem.characters(number: 20) }
    user
    genre
  end
end