Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  namespace :api, format: "json" do
    namespace :v1 do
      # enums
      resources :cosmonauts
    end
  end
end
