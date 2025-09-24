class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :role])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :role])
  end

  # ログイン後
  def after_sign_in_path_for(resource)
    events_path
  end

  # サインアップ直後
  def after_sign_up_path_for(resource)
    events_path
  end

  # ログアウト後
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
