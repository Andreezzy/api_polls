require 'rails_helper'
RSpec.describe Api::V1::UsersController, type: :request do
  describe "POST /users" do
    before :each do
      auth = { provider: "facebook", uid: "12fgwbye", info: { email: "andres@gmail.com" } }
      post "/api/v1/users", { auth: auth }
    end
    it { have_http_status(200) }
    it { change(User, :count).by(1) }
    it "responds with the user found or created" do
      json = JSON.parse(response.body)
      expect(json["email"]).to eq("andres@gmail.com")
    end
  end
end