class StoresController < ApplicationController
  before_filter :authorize!, :except => :index

  def index
    @stores = Store.all
  end

  def update
    @store = Store.find(params[:id])
    if @store.update_attributes(params[:store])
      render :json => @store, :status => :accepted
    else
      render :json => @store.errors, :status => :unprocessable_entity
    end
  end

  def remove_picture
    @store = Store.find(params[:id])
    @store.update_attribute(:picture, nil)
    head :accepted
  end
end
