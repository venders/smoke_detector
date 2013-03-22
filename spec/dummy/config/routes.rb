Dummy::Application.routes.draw do
  match '/widgets/bubble_up' => 'widgets#bubble_up'
  match '/widgets/deep_bubble_up' => 'widgets#deep_bubble_up'
  match '/widgets/catch' => 'widgets#catch'
  match '/widgets/deep_catch' => 'widgets#deep_catch'
end
