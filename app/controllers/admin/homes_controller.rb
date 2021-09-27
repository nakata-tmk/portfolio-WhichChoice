class Admin::HomesController < ApplicationController
  def top
    @questions = Question.page(params[:page])
    @genres = Genre.all
  end
  
  def search
    @title = "「#{params[:keyword]}」の検索結果"
    if params[:keyword].present?
     @questions = Question.where(['object1 LIKE? OR object1 LIKE? OR body LIKE?',
      "%#{params[:keyword]}%", "%#{params[:keyword]}%", "%#{params[:keyword]}%"]).page(params[:page])
    else
     @questions = Question.none
    end
  end
end
