class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :login_user!


  def current_user
    User.find_by(session_token: session[:session_token])
  end

  def login_user!
    user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password]
    )

    if user
      user.reset_session_token!
      session[:session_token] = user.session_token
      flash[:notice] = "Welcome #{user.username.capitalize}!"
      redirect_to cats_url
    else
      flash[:errors] = ["Invalid credentials"]
      render :new
    end
  end

  def already_logged_in
    user = current_user
    if user
      redirect_to cats_url
    end
  end

  def ensure_ownership
    cat = current_user.cats.where(user_id: current_user.id)
    unless cat.exists?
      flash[:errors] = ["Cannot edit somebody else's cat!!!!!"]
      redirect_to cats_url
    end
  end

end
