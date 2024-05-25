Rails.application.routes.draw do
  get 'csv_imports/new'
  get 'csv_imports/create'
  get 'movies/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root 'movies#index'
  resources :movies, only: [:index, :show]

  get 'import_csv', to: 'csv_imports#new'
  post 'import_movies_csv', to: 'csv_imports#import_movies'
  post 'import_reviews_csv', to: 'csv_imports#import_reviews'

  get 'movies_csv_structure', to: 'csv_imports#movies_csv_structure'
  get 'reviews_csv_structure', to: 'csv_imports#reviews_csv_structure'

end

