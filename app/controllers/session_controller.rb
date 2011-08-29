class SessionController < ApplicationController
  def new
  end

  def create
    password = ENV["PASSWORD"] || "password"
    session[:logged_in] = 1 if params[:password] == password
    redirect_to root_path
  end

  def destroy
    reset_session
    redirect_to root_path
  end
end
