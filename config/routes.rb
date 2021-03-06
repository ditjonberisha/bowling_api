Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :games, only: %w[create show] do
        resources :points, only: :create, controller: 'games/points'
      end
    end
  end

  root 'api/v1/base#api'
end
