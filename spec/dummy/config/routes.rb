Dummy::Application.routes.draw do
  resources :widgets, only: :index
  get '/widgets/bubble_up' => 'widgets#bubble_up'
  get '/widgets/deep_bubble_up' => 'widgets#deep_bubble_up'
  get '/widgets/catch' => 'widgets#catch'
  get '/widgets/deep_catch' => 'widgets#deep_catch'
end
