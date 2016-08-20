class ResultsController < ApplicationController
  def new
    @result = Result.new
  end

  def index
  end

  def show
  end

  def create
  end

  private
  def results_params
    params.require(:result).permit(:message, :date, :username)
  end
end
