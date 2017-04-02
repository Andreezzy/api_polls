require 'rails_helper'

RSpec.describe Api::V1::QuestionsController, type: :request do

  before :each do
    @token = FactoryGirl.create(:token, expires_at: DateTime.now + 1.month)
    @poll = FactoryGirl.create(:poll_with_questions, user: @token.user)
  end

  describe "GET /polls/:poll_id/questions" do
    before :each do
      get "/api/v1/polls/#{@poll.id}/questions"
    end

    it { expect(response).to have_http_status(200) }
    it "mande la lista de preguntas de la encuestas" do
      json = JSON.parse(response.body)
      expect(json.length).to eq(@poll.questions.count)
    end

    it "manda la descripction y el id de una pregunta" do
      json_array =JSON.parse(response.body)
      puts "--- \n\n\n #{json_array} \n\n\n---"
      question = json_array[0]
      expect(question.keys).to contain_exactly("id", "description")
    end
  end


  describe "POST /polls/:poll_id/questions" do
    context "con usuario valido" do
      before :each do
        post api_v1_poll_questions_path(@poll), { question: { description: "¿Cual es tu lenguaje favorito?" }, token: @token.token }
      end

      it { expect(response).to have_http_status(200) }

      it "cambia el numero de preguntas +1" do
        expect {
          post api_v1_poll_questions_path(@poll), { question: { description: "¿Cual es tu lenguaje favorito?" }, token: @token.token }
        }.to change(Question, :count).by(1)
      end

      it "responde con la pregunta creada" do
        json = JSON.parse(response.body)
        expect(json["description"]).to eq("¿Cual es tu lenguaje favorito?")
      end
    end

    context "con usuario invalido" do
      before :each do
        new_user = FactoryGirl.create(:dummy_user)
        @new_token = FactoryGirl.create(:token, user: new_user, expires_at: DateTime.now + 1.month)
        post api_v1_poll_questions_path(@poll), { question: { description: "¿Cual es tu lenguaje favorito?" }, token: @new_token.token }
      end

      it { expect(response).to have_http_status(401) }

      it "no cambia el numero de preguntas" do
        expect {
          post api_v1_poll_questions_path(@poll), { question: { description: "¿Cual es tu lenguaje favorito?" }, token: @new_token.token }
        }.to change(Question, :count).by(0)
      end
    end
  end

  describe "PUT/PATCH /polls/:poll_id/questions/:id" do
    before :each do
      @question = @poll.questions[0]
      patch api_v1_poll_question_path(@poll,@question), { question: { description: "Hola mundo" }, token: "fake" }
    end

    it { expect(response).to have_http_status(200) }

    it "Actualiza los datos indicados" do
      json = JSON.parse(response.body)
      expect(json["description"]).to eq("Hola mundo")
    end

  end

  describe "DELETE /polls/:poll_id/questions/:id" do
    before :each do
      @question = @poll.questions[0]
    end

    it "responde con status 200" do
      delete api_v1_poll_question_path(@poll,@question), { token: @token.token }
      expect(response).to have_http_status(200)
    end

    it "elimina la prueba " do
      delete api_v1_poll_question_path(@poll,@question), { token: @token.token }
      expect(Question.where(id: @question.id)).to be_empty
    end
    it "reduce el conteo de preguntas en -1" do
      expect{
        delete api_v1_poll_question_path(@poll,@question), { token: @token.token }
      }.to change(Question, :count).by(-1)
    end
  end
end