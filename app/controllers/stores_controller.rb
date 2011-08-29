class StoresController < ApplicationController
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
end
