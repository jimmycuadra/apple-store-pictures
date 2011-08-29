AppleStorePictures::Application.routes.draw do
  resources :stores, :only => [:index, :update]

  root :to => "stores#index"
end
