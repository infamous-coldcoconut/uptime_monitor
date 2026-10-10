Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "sites#index"

  # rozcestníky funkcí?
  resources :sites, only: [ :index, :create, :destroy ]
end
