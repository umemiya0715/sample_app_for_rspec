FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "title_#{n}" }
    content { "content" }
    status { :todo } 
    deadline { 1.week.from_now }
    association :user
  end
end
