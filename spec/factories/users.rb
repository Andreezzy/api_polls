FactoryGirl.define do
  factory :user do
    email "andres@gmail.com"
    name "Andres"
    provider "google"
    uid "asfgaspaolaratawrnvs"
    factory :dummy_user do
      email "frank@gmail.com"
      name "Frank"
      provider "facebook"
      uid "asfgaspaolaratawrnvs"
    end
    factory :sequence_user do
      sequence(:email) { |n| "person#{n}@example.com" }
      name "Frank"
      provider "facebook"
      uid "asfgaspaolaratawrnvs"
    end
  end
end
