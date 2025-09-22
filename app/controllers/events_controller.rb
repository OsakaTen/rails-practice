# app/controllers/events_controller.rb
class EventsController < ApplicationController
  # 各アクションの前に実行する処理
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :check_management_permission, except: [:show]

  # GET /events - イベント一覧表示
  def index
    @events = current_user.events.order(event_date: :desc)
  end

  # GET /events/:id - イベント詳細表示（公開用）
  def show
    # 認証不要で誰でもアクセス可能
  end

  # GET /events/new - 新規イベント作成フォーム
  def new
    @event = current_user.events.build
  end

  # POST /events - 新規イベント保存
  def create
    @event = current_user.events.build(event_params)
    
    if @event.save
      # 保存成功時
      redirect_to events_path, notice: 'イベントが正常に作成されました。'
    else
      # 保存失敗時（入力エラーなど）
      render :new, status: :unprocessable_entity
    end
  end

  # GET /events/:id/edit - イベント編集フォーム
  def edit
  end

  # PATCH/PUT /events/:id - イベント更新
  def update
    if @event.update(event_params)
      redirect_to events_path, notice: 'イベントが正常に更新されました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /events/:id - イベント削除
  def destroy
    @event.destroy
    redirect_to events_path, notice: 'イベントが削除されました。'
  end

  private

  # 対象イベントを取得
  def set_event
    if action_name == 'show' && !user_signed_in?
      # 公開アクセスの場合（ログインしていない）
      @event = Event.find_by!(public_token: params[:id])
    else
      # 管理用アクセスの場合（ログイン済み）
      @event = current_user.events.find_by!(public_token: params[:id])
    end
  end

  # フォームから受け取るパラメータを制限（セキュリティ対策）
  def event_params
    params.require(:event).permit(:title, :description, :event_date, :organizer_name, :target_departments)
  end

  # 管理権限をチェック
  def check_management_permission
    redirect_to root_path, alert: '権限がありません。' unless current_user&.can_manage_events?
  end
end