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
    @answers0_all = Answer.where(question_id: @question.id, answer: 0)
    @answers1_all = Answer.where(question_id: @question.id, answer: 1)

    @answers_sex = {a0: {man: [], woman: []}, a1: {man: [], woman: []}}
    (0..1).each do |num|
      tmp = Answer.where(question_id: @question.id, answer: num)
      tmp.each do |user|
        if user.user.sex == 'man'
          @answers_sex[:a0][:man] << user.user if num == 0
          @answers_sex[:a1][:man] << user.user if num == 1

        else
          @answers_sex[:a0][:woman] << user.user if num == 0
          @answers_sex[:a1][:woman] << user.user if num == 1
          @answers0_woman = @answers_sex[:a0][:woman]
          @answers1_woman = @answers_sex[:a1][:woman]
        end
      end
    end

    @answers_age = {a0: {teens: [], twenties: [], thirties: [], forties: [], fifties: [], sixties: []},
                    a1: {teens: [], twenties: [], thirties: [], forties: [], fifties: [], sixties: []}}
    (0..1).each do |num|
      tmp = Answer.where(question_id: @question.id, answer: num)
      tmp.each do |user|
        if user.user.age == 'teens'
          @answers_age[:a0][:teens] << user.user if num == 0
          @answers_age[:a1][:teens] << user.user if num == 1
        elsif user.user == 'twenties'
          @answers_age[:a0][:twenties] << user.user if num == 0
          @answers_age[:a1][:twenties] << user.user if num == 1
        elsif user.user == 'thirties'
          @answers_age[:a0][:thirties] << user.user if num == 0
          @answers_age[:a1][:thirties] << user.user if num == 1
        elsif user.user == 'forties'
          @answers_age[:a0][:forties] << user.user if num == 0
          @answers_age[:a1][:forties] << user.user if num == 1
        elsif user.user == 'fifties'
          @answers_age[:a0][:fifties] << user.user if num == 0
          @answers_age[:a1][:fifties] << user.user if num == 1
        else
          @answers_age[:a0][:sixties] << user.user if num == 0
          @answers_age[:a1][:sixties] << user.user if num == 1
        end
      end
    end

    @answers_area = {a0: {hokkaidou: [], touhoku: [], kantou: [], cyuubu: [], kansai: [], cyuugoku: [], shikoku: [], kyuusyuu: []},
                    a1: {hokkaidou: [], touhoku: [], kantou: [], cyuubu: [], kansai: [], cyuugoku: [], shikoku: [], kyuusyuu: []}}
    (0..1).each do |num|
      tmp = Answer.where(question_id: @question.id, answer: num)
      tmp.each do |user|
        if user.user.area == 'hokkaidou'
          @answers_area[:a0][:hokkaidou] << user.user if num == 0
          @answers_area[:a1][:hokkaidou] << user.user if num == 1
        elsif user.user.area == 'touhoku'
          @answers_area[:a0][:touhoku] << user.user if num == 0
          @answers_area[:a1][:touhoku] << user.user if num == 1
        elsif user.user.area == 'kantou'
          @answers_area[:a0][:kantou] << user.user if num == 0
          @answers_area[:a1][:kantou] << user.user if num == 1
        elsif user.user.area == 'cyuubu'
          @answers_area[:a0][:cyuubu] << user.user if num == 0
          @answers_area[:a1][:cyuubu] << user.user if num == 1
        elsif user.user.area == 'kansai'
          @answers_area[:a0][:kansai] << user.user if num == 0
          @answers_area[:a1][:kansai] << user.user if num == 1
        elsif user.user.area == 'cyuugoku'
          @answers_area[:a0][:cyuugoku] << user.user if num == 0
          @answers_area[:a1][:cyuugoku] << user.user if num == 1
        elsif user.user.area == 'shikoku'
          @answers_area[:a0][:shikoku] << user.user if num == 0
          @answers_area[:a1][:shikoku] << user.user if num == 1
        else
          @answers_area[:a0][:kyuusyuu] << user.user if num == 0
          @answers_area[:a1][:kyuusyuu] << user.user if num == 1
        end
      end
    end
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
