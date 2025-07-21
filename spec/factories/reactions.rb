FactoryBot.define do
  factory :reaction do
    reaction { "👍" }
    user { association(:user) }
    post { association(:post) }
  end
end
