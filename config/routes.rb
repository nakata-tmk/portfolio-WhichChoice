Rails.application.routes.draw do
  namespace :admin do
    devise_for :admins, path: '/', controllers: {
      sessions: 'admin/admins/sessions',
      registrations: 'admin/admins/registrations',
      passwords: 'admin/admins/passwords'
    }
    resources :genres, only: [:index, :create, :edit, :update]
    resources :users, only: [:index, :show, :edit, :update]
    resources :questions, only: [:show, :destroy]
    get '/' => 'homes#top', as: 'top'
    get '/search' => 'homes#search'
  end


  scope module: :public do
    root to: 'homes#top'
    get '/about' => 'homes#about', as: 'about'

    resource :users, only: [:show, :edit, :update] do
      collection do
        get :leave
        patch :withdraw
      end
    end

    resources :questions do
      resources :comments, only: [:create, :destroy]
      resource :favorites, only: [:create, :destroy]
      collection do
        get :search
      end
    end

    resource :answer, only: [:create]

    devise_for :users, controllers: {
      sessions: 'public/users/sessions',
      registrations: 'public/users/registrations',
      passwords: 'public/users/passwords'
    }

    devise_scope :user do
      post '/users/guest_sign_in' => 'users/sessions#guest_sign_in'
    end



  end

end
