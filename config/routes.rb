AppleStorePictures::Application.routes.draw do
  resources :stores, :only => [:index, :update] do
    put "remove_picture", :on => :member
  end

  root :to => "stores#index"
end
