Rails.application.routes.draw do
  devise_for :admins, path: 'admin/'

  namespace :admin do
    devise_for :admins, controllers: {
      sessions: 'admin/admins/sessions',
      registrations: 'admin/admins/registrations',
      passwords: 'admin/admins/passwords'
    }
    resources :genres, only: [:index, :create, :edit, :update]
    resources :users, only: [:index, :show, :edit, :update]
  end

  scope module: :public do
    root to: 'homes#top'
    get '/about' => 'homes#about', as: 'about'

    resource :users, only: [:show, :edit, :update]
    get '/users/leave' => 'users#leave', as: 'users_leave'
    patch '/users/withdraw' => 'users#withdraw', as: 'users_withdraw'

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
