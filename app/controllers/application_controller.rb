class ApplicationController < ActionController::Base
  protect_from_forgery

  def authorize!
    render :text => "Unauthorized", :status => :unauthorized unless session[:logged_in]
  end
end
