class SessionsController < ApplicationController
  layout "authentication"

  skip_before_action :authenticate_user!, only: [ :new, :create ]

  def new
    @user = User.new
  end

  def create
    if user = User.authenticate_by(login_params)
      login user
      redirect_to posts_path, notice: "You have signed successfully"
    else
      flash[:alert] = "Invalid email or password"
      @user = User.new
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: "You have been logged out"
  end

  private

  def login_params
    params.require(:user).permit(:email, :password)
  end
end
