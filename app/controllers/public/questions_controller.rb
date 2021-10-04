class Public::QuestionsController < ApplicationController
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
      questions = Question.sort(params[:sort]).where(genre_id: params[:genre_id])
      @questions = Kaminari.paginate_array(questions).page(params[:page])
    elsif params[:sort].present?
      questions = Question.sort(params[:sort])
      @questions = Kaminari.paginate_array(questions).page(params[:page])
    elsif params[:genre_id].present?
      @genre = Genre.find(params[:genre_id])
      @questions = @genre.questions.page(params[:id])
    else
      @questions = Question.page(params[:page])
    end
    @genre.present? ? @name = @genre.name : @name = "投稿"
    @sort_list = Question.sort_list
  end

  def show
    @question = Question.find(params[:id])
    @answer = Answer.new
    @comment = Comment.new
    @counts_object1 = Answer.where(question_id: @question.id, answer: 0).count
    @counts_object2 = Answer.where(question_id: @question.id, answer: 1).count
  end

  def new
    @question = Question.new
  end

  def create
    question = Question.new(question_params)
    if question.save
      redirect_to questions_path, notice: '新規作成しました'
    else
      @questions = Question.page(params[:page])
      render :index
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
      render :show
    end
  end

  def destroy
    question = Question.find(params[:id])
    question.destroy
    redirect_to questions_path
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

  private
    def question_params
      params.require(:question).permit(:user_id, :genre_id, :object1, :object2, :body)
    end
end
