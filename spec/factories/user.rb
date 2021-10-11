FactoryBot.define do
  factory :user do
    name { Faker::Lorem.characters(number: 10) }
    email { Faker::Internet.email }
    sex { 'man' }
    age { 'teens' }
    area { 'hokkaidou' }
    password { 'password' }
    password_confirmation { 'password' }
  end
end