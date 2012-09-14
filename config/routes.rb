RimOnRails::Application.routes.draw do
  get "rim_classes/index"

  resources :rim_classes

  root :to => "welcome#index"
end
