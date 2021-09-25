Rails.application.routes.draw do

scope module: :public do
  root to: 'homes#top'
  get '/about' => 'homes#about', as: 'about'

  devise_for :users, controllers: {
    sessions: 'public/users/sessions',
    registrations: 'public/users/registrations',
    passwords: 'public/users/passwords'
  }
end

end
