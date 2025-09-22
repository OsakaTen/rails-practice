class PublicEventsController < ApplicationController
  # 認証を不要にする
  skip_before_action :authenticate_user!

  # GET /public/events/:token - 公開イベント詳細
  def show
    @event = Event.find_by!(public_token: params[:token])
  end
end
