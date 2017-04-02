class Api::V1::QuestionsController < ApplicationController
  before_action :authenticate, except: [:index, :show]
  before_action :set_question, only: [:show, :update, :destroy]
  before_action :set_poll
  before_action(only: [:update, :destroy, :create]) { |controlador| controlador.authenticate_owner(@poll.user) }

  def index
    @poll = MyPoll.find(params[:poll_id])
    @questions = @poll.questions
  end

  def show
  end

  def create
    @question = @poll.questions.new(question_params)
    if @question.save
      render "api/v1/questions/show"
    else
      render json: { error: @question.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @question.update(question_params)
      render template: "api/v1/questions/show"
    else
      render json: { error: @question.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @question.destroy
    head :ok
  end

  private
  def set_poll
    @poll = MyPoll.find(params[:poll_id])
  end

  def question_params
    params.require(:question).permit(:description)
  end

  def set_question
    @question = Question.find(params[:id])
  end
end