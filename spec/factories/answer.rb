FactoryBot.define do
  factory :answer do
    answer { '0' }
    user
    question
  end
end