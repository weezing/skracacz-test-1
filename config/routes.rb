Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :links, only: :create
    end
  end

  get '/:slug', to: 'links#show'
end
