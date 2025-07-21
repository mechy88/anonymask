class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :edit, :update, :destroy, :update_role ]
  before_action :require_admin

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: "User was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to users_path, notice: "User was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: "User was successfully deleted."
  end

  # Unified promote/demote logic
  def update_role
    if @user.id == current_user.id
      redirect_to users_path, alert: "You cannot change your own role."
      return
    end

    @user.role = @user.admin? ? "user" : "admin"

    if @user.save
      action = @user.admin? ? "promoted to admin" : "demoted to user"
      redirect_to users_path, notice: "#{@user.username} #{action}."
    else
      redirect_to users_path, alert: "Failed to update role."
    end
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
    unless @user
      redirect_to users_path, alert: "User not found."
    end
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :role)
  end

  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "Access denied."
    end
  end
end
