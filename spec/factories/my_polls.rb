FactoryGirl.define do
  factory :my_poll do
    association :user, factory: :sequence_user
    expires_at "2018-05-26 12:54:08"
    title "MyStrdsfsdfsdfing"
    description "MyTefasfasfasfsafasasfdgffxt"
    factory :poll_with_questions do
      title "Poll with questions"
      description "MyTefasfasfasfsafasasfdgffxt"
      questions { build_list :question, 2 }
    end
  end
end
