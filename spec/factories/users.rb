# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "testuser#{n}" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "securepassword" }
    password_confirmation { "securepassword" }
    role { "user" }
  end
end
