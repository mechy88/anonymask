FactoryBot.define do
  factory :comment do
    content { "Test comment content" }
    association :user
    association :post
  end
end
