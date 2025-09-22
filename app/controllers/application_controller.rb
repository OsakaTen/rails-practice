class ApplicationController < ActionController::Base 
  allow_browser versions: :modern

  # Deviseコントローラーを除外してログイン必須に
  before_action :authenticate_user!, unless: :devise_controller?

  # Deviseで追加情報も受け取れるように設定
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # ユーザー登録時に名前と役割も保存できるように
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :role])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :role])
  end
end
