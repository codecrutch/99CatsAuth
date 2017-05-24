class UsersController < ApplicationController
  before_action :already_logged_in

  def create
    @user = User.new(user_params)
    if @user.save
      login_user!
    else
      flash[:errors] = @user.errors.full_messages
      redirect_to new_user_url
    end
  end

  def new
    @user = User.new
    render :new
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
