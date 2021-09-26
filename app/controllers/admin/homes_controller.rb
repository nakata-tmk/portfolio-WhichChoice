class Admin::HomesController < ApplicationController
  def top
    @questions = Question.page(params[:page])
  end
end
