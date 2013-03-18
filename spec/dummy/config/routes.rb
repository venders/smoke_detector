Dummy::Application.routes.draw do
  resources :widgets, only: [:index]
end
