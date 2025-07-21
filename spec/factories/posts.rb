FactoryBot.define do
  factory :post do
    title { "baduy" }
    content { "Alam mo kasi kasalanan to lahat ni conor" }
    status { "unseen" }
    user { association(:user) }
  end
end
