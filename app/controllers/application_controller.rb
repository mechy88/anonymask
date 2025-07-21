class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!
  before_action :set_current_user

  private

  # Sets Current.user before each request if user is signed in
  def set_current_user
    Current.user = current_user if user_signed_in?
  end

  # Ensures the user is logged in before continuing
  def authenticate_user!
    redirect_to root_path, alert: "You must be logged in to do that." and return unless user_signed_in?
  end

  # Used when a user tries to access or modify something they don't own
  def user_authorization_needed
    redirect_to posts_path, alert: "You are not authorized to perform that action." and return
  end

  def current_user
    Current.user ||= authenticate_user_from_session
  end
  helper_method :current_user

  def authenticate_user_from_session
    User.find_by(id: session[:user_id])
  end

  def user_signed_in?
    current_user.present?
  end
  helper_method :user_signed_in?

  def login(user)
    Current.user = user
    reset_session
    session[:user_id] = user.id
  end

  def logout
    Current.user = nil
    reset_session
  end

  def admin_only!
    redirect_to root_path, alert: "Admins only!" and return unless current_user&.admin?
  end
end
