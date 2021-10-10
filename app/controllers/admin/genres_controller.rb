class Admin::GenresController < ApplicationController
  before_action :authenticate_admin_admin!

  def index
    @genres = Genre.all
    @genre = Genre.new
  end

  def create
    genre = Genre.new(genre_params)
    if genre.save
      redirect_to admin_genres_path, notice: '新規作成しました'
    else
      @genres = Genre.all
      @genre = genre
      render :index
    end
  end

  def edit
    @genre = Genre.find(params[:id])
  end

  def update
    genre = Genre.find(params[:id])
    if genre.update(genre_params)
      redirect_to admin_genres_path, notice: '更新しました'
    else
      @genre = genre
      render :edit
    end
  end

  private
    def genre_params
      params.require(:genre).permit(:name)
    end
end
