class SessionsController < ApplicationController
  before_action :already_logged_in, except: [:destroy]

  def new
    render :new
  end

  def create
    login_user!
  end

  def destroy
    user = current_user
    if user
      user.reset_session_token!
      session[:session_token] = nil
    end
    redirect_to new_session_url
  end
end
