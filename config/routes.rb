Rails.application.routes.draw do
  get "up" => "rails/health#show", :as => :rails_health_check

  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  namespace :api, format: "json" do
    namespace :v1 do
      resources :cosmonauts do
        collection do
          get :export
          post :import
        end
      end
    end
  end
end
