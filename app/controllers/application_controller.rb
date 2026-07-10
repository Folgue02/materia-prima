class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes

  helper_method :current_user, :logged_in?, :admin?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  def admin?
    logged_in? && current_user.admin?
  end

  def require_login
    unless logged_in?
      flash[:alert] = "You must be logged in to do that."
      redirect_to login_path
    end
  end

  def require_admin
    unless admin?
      flash[:alert] = "You must be an admin to do that."
      redirect_to root_path
    end
  end
end
