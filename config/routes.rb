UdSync::Engine.routes.draw do
  resources :operations, only: [:index]
end
