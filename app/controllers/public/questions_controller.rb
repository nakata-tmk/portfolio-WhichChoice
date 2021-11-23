class Public::QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :check_guest, only: [:create, :update, :destroy]
  def check_guest
    if current_user.email == 'guest@example.com'
      redirect_to root_path, alert: 'ゲストユーザーのため権限がありません'
    end
  end

  def index
    @genres = Genre.all
    if params[:sort].present? && params[:genre_id].present?
      @genre = Genre.find(params[:genre_id])
      @questions = Question.sort(params[:sort], params[:genre_id]).page(params[:page])
    elsif params[:sort].present?
      @questions = Question.sort(params[:sort], params[:genre_id]).page(params[:page])
    elsif params[:genre_id].present?
      @genre = Genre.find(params[:genre_id])
      @questions = @genre.questions.page(params[:id]).order(created_at: :desc)
    else
      @questions = Question.page(params[:page]).order(created_at: :desc)
    end
    @genre.present? ? @name = @genre.name : @name = "アンケート"
    @sort_list = Question.sort_list
  end

  def show
    @question = Question.find(params[:id])
    @answer = Answer.new
    @comment = Comment.new
  end

  def new
    @question = Question.new
  end

  def create
    question = Question.new(question_params)
    if question.save
      redirect_to questions_path, notice: '新規作成しました'
    else
      @question = question
      render :new
    end
  end

  def edit
    @question = Question.find(params[:id])
  end

  def update
    question = Question.find(params[:id])
    if question.update(question_params)
      redirect_to question_path(params[:id]), notice: '更新しました'
    else
      @question = question
      render :edit
    end
  end

  def destroy
    question = Question.find(params[:id])
    question.destroy
    redirect_to questions_path
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

  private
    def question_params
      params.require(:question).permit(:user_id, :genre_id, :object1, :object2, :body)
    end
end
