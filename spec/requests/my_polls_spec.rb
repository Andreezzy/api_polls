require 'rails_helper'
RSpec.describe Api::V1::MyPollsController, type: :request do
  describe "GET /polls" do
    before :each do
      FactoryGirl.create_list(:my_poll, 10)
      get "/api/v1/polls"
    end

    it { expect(response).to have_http_status(200) }

    it "mande la lista de encuestas" do
      json = JSON.parse(response.body)
      expect(json.length).to eq(MyPoll.count)
    end
  end

  describe "GET /polls/:id" do
    before :each do
      @poll = FactoryGirl.create(:my_poll)
      get "/api/v1/polls/#{@poll.id}"
    end

    it { expect(response).to have_http_status(200) }

    it "manda la encuesta solicitada" do
      json = JSON.parse(response.body)
      expect(json["id"]).to eq(@poll.id)
    end
    it "manda los atributos de la encuesta" do
      json = JSON.parse(response.body)
      expect(json.keys).to contain_exactly("id", "title", "description", "expires_at", "user_id")
    end
  end

  describe "POST /polls" do
    context "con token valid" do
      before :each do
        @token = FactoryGirl.create(:token, expires_at: DateTime.now + 10.minutes)
        post "/api/v1/polls/", { token: @token.token, poll: { title: "Hola mundo", description: "nfsafnaiunfsiaunfsaiufnsa", expires_at: DateTime.now } }
      end

      it { expect(response).to have_http_status(200) }

      it "crea una nueva encuesta" do
        expect{
          post "/api/v1/polls/", { token: @token.token, poll: { title: "Hola mundo", description: "nfsafnaiunfsiaunfsaiufnsa", expires_at: DateTime.now } }
        }.to change(MyPoll, :count).by(1)
      end
      it "responde con la encuesta creada" do
        json = JSON.parse(response.body)
        expect(json["title"]).to eq("Hola mundo")
      end
    end
    context "con token invalido" do
      before :each do
        post "/api/v1/polls/"
      end
    end
    context "unvalid params" do
      before :each do
        @token = FactoryGirl.create(:token, expires_at: DateTime.now + 10.minutes)
        post "/api/v1/polls/", { token: @token.token, poll: { title: "Hola mundo", expires_at: DateTime.now } }
      end

      it { expect(response).to have_http_status(422) }

      it "responde con los errores al guardar la encuesta" do
        json = JSON.parse(response.body)
        expect(json["errors"]).to_not be_empty
      end
    end
  end

  describe "PATCH /polls/:id" do
    context "con un token valido" do
      before :each do
        @token = FactoryGirl.create(:token, expires_at: DateTime.now + 10.minutes)
        @poll = FactoryGirl.create(:my_poll, user: @token.user)
        patch api_v1_poll_path(@poll), { token: @token.token, poll: {  title: "Nuevo titulo"} }
      end
      it { expect(response).to have_http_status(200) }

      it "actualiza la encuesta indicada" do
        json = JSON.parse(response.body)
        expect(json["title"]).to eq("Nuevo titulo")
      end
    end
    context "con un token invalido" do
      before :each do
        @token = FactoryGirl.create(:token, expires_at: DateTime.now + 10.minutes)
        @poll = FactoryGirl.create(:my_poll, user: FactoryGirl.create(:dummy_user))
        patch api_v1_poll_path(@poll), { token: @token.token, poll: { title: "cambiando con otro user" } }
      end
      it { expect(response).to have_http_status(401) }
    end
  end

  describe "DELETE /polls/:id" do
    context "con un token valido" do
      before :each do
        @token = FactoryGirl.create(:token, expires_at: DateTime.now + 10.minutes)
        @poll = FactoryGirl.create(:my_poll, user: @token.user)
      end
      it {
        delete api_v1_poll_path(@poll), { token: @token.token }
        expect(response).to have_http_status(200)
      }

      it "elimina la encuesta indicada" do
        expect{
          delete api_v1_poll_path(@poll), { token: @token.token }
        }.to change(MyPoll, :count).by(-1)
      end
    end
    context "con un token invalido" do
      before :each do
        @token = FactoryGirl.create(:token, expires_at: DateTime.now + 10.minutes)
        @poll = FactoryGirl.create(:my_poll, user: FactoryGirl.create(:dummy_user))
        delete api_v1_poll_path(@poll), { token: @token.token }
      end
      it { expect(response).to have_http_status(401) }
    end
  end

end