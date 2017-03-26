FactoryGirl.define do
  factory :token do
    expires_at "2017-03-25 12:02:06"
    association :user, factory: :user
  end
end
