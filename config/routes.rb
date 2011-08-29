AppleStorePictures::Application.routes.draw do
  resources :stores, :only => [:index, :update] do
    put "remove_picture", :on => :member
  end

  match "/login" => "session#new", :via => :get
  match "/login" => "session#create", :via => :post
  match "/logout" => "session#destroy", :via => :get

  root :to => "stores#index"
end
