class Api::V1::MyPollsController < ApplicationController
  before_action :authenticate, only: [:create, :update, :destroy]
  before_action :set_poll, only: [:show, :update, :destroy]
  before_action(only: [:update, :destroy]) { |controlador| controlador.authenticate_owner(@poll.user) }
  def index
    @polls = MyPoll.all
  end

  def show
  end

  def create
    @poll = @current_user.my_polls.new(my_polls_params)
    if @poll.save
      render "api/v1/my_polls/show"
    else
      render json: { errors: @poll.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @poll.update(my_polls_params)
    render "api/v1/my_polls/show"
  end

  def destroy
    @poll.destroy
    render json: { message: "Fue eliminada la encuesta" }
  end

  protected
  def authenticate_owner(owner)
    if owner != @current_user
      render json: { errors: "No tienes autorizado modificar esa encuesta" }, status: 401
    end
  end

  private
  def set_poll
    @poll = MyPoll.find(params[:id])
  end
  def my_polls_params
    params.require(:poll).permit(:title, :description, :expires_at)
  end
end