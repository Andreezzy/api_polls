require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should_not allow_value("andres@codigo").for(:email) }
  it { should allow_value("andres@gmail.com").for(:email) }
  it { should validate_presence_of(:uid) }
  it { should validate_presence_of(:provider) }
  it { should validate_uniqueness_of(:email) }

  it "should create a new user if uid and provider don't exist" do
    expect{
      User.from_omniauth({uid: "12345", provider: "google", info: {email: "andres@gmail.com"}})
    }.to change(User, :count).by(1)
  end
  it "should found a user if uid and provider exist" do
    user = FactoryGirl.create(:user)
    expect{
      User.from_omniauth({uid: user.uid, provider: user.provider, info: {email: "andres@gmail.com"}})
    }.to change(User, :count).by(0)
  end
  it "deberia retornar el usuario encontrado si el uid y el provider ya existen" do
    user = FactoryGirl.create(:user)
    expect(
      User.from_omniauth({uid: user.uid, provider: user.provider, info: {email: "andres@gmail.com"}})
    ).to eq(user)
  end
end
