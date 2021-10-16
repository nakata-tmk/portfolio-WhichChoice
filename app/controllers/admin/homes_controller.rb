class Admin::HomesController < ApplicationController
  before_action :authenticate_admin_admin!

  def top
    @genres = Genre.all
    if params[:sort].present? && params[:genre_id].present?
      @genre = Genre.find(params[:genre_id])
      questions = Question.sort(params[:sort]).where(genre_id: params[:genre_id])
      @questions = Kaminari.paginate_array(questions).page(params[:page])
    elsif params[:sort].present?
      questions = Question.sort(params[:sort])
      @questions = Kaminari.paginate_array(questions).page(params[:page])
    elsif params[:genre_id].present?
      @genre = Genre.find(params[:genre_id])
      @questions = @genre.questions.page(params[:id])
    else
      @questions = Question.page(params[:page]).order(created_at: :desc)
    end
    @genre.present? ? @name = @genre.name : @name = "アンケート"
    @sort_list = Question.sort_list
  end

  def search
    @genres = Genre.all
    @title = "「#{params[:keyword]}」の検索結果"
    if params[:keyword].present?
     @questions = Question.where(['object1 LIKE? OR object1 LIKE? OR body LIKE?',
      "%#{params[:keyword]}%", "%#{params[:keyword]}%", "%#{params[:keyword]}%"]).page(params[:page])
    else
     @questions = Question.none
    end
  end
end
