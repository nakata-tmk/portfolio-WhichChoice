FactoryBot.define do
  factory :admin do
    email { Faker::Internet.email(domain: 'test') }
    password { Faker::Internet.password }
    password_confirmation { Faker::Internet.password }
  end
end