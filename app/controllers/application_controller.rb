class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # デフォルトは「ログイン必須」
  before_action :authenticate_user!

  # Devise の追加カラムを許可
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # サインアップ・アカウント更新時に追加カラムを許可
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :role])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :role])
  end

  # ログイン後のリダイレクト先を明示
  def after_sign_in_path_for(resource)
    events_path
  end
end
