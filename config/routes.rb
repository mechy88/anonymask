Rails.application.routes.draw do
  root "sessions#new"

  resources :users do
    member do
      patch :update_role
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Authentication Related Paths
  resource :registration
  resource :session
  resource :password_reset
  resource :password

  # Post management with admin status actions
  resources :posts do
    member do
      patch :mark_seen
      patch :mark_resolved
    end
    resources :reactions

    # Nested comment routes for CRUD
    resources :comments, only: [ :create, :edit, :update, :destroy, :show ]
  end
end
