class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  # 全ページで認証を要求しない（各コントローラーで制御）
  
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  #Aiで書きました
  def configure_permitted_parameters
    # 新規登録時に first_name, last_name, role を許可
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :role])
    
    # アカウント更新時に first_name, last_name, role を許可
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :role])
  end

  # ログイン後のリダイレクト先
  def after_sign_in_path_for(resource)
    events_path
  end

  # サインアップ直後のリダイレクト先
  def after_sign_up_path_for(resource)
    events_path
  end

  # ログアウト後のリダイレクト先
  def after_sign_out_path_for(resource_or_scope)
    root_path 
  end
end
