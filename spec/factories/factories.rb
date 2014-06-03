FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@factory.com"
  end

  sequence :name do |n|
    "user_#{n}"
  end

  factory :user do
    email
    name
    password "foobar"
    password_confirmation "foobar"
    gender 0
    age 25
  end
end

FactoryGirl.define do
  factory :meeting do
    sequence(:name) {|n| "meeting_#{n}" }
    started_at Time.zone.now
  end
end