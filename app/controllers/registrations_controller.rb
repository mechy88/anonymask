class RegistrationsController < ApplicationController
  layout "authentication"

  skip_before_action :authenticate_user!, only: [ :new, :create ]
  def new
    @user = User.new
  end

  def create
    @user = User.new(registration_params)
    @user.role = "user"

    if @user.save
      login @user
      redirect_to posts_path, notice: "You have signed successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def registration_params
    params.require(:user).permit(:email, :password, :password_confirmation, :username)
  end
end
