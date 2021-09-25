Rails.application.routes.draw do

scope module: :public do
  root to: 'homes#top'
  get '/about' => 'homes#about', as: 'about'
end

end
