class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:show_public]
  before_action :set_event, only: [:show, :edit, :update, :destroy, :show_public]
  before_action :authorize_admin!, except: [:show_public, :index]

  def index
    @events = current_user.admin? ? Event.all : current_user.events
  end

  def show; end

  def new
    @event = current_user.events.new
  end

  def create
    @event = current_user.events.new(event_params)
    if @event.save
      redirect_to events_path, notice: "イベント登録完了！公開URL: #{show_public_event_url(@event)}"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @event.update(event_params)
      redirect_to events_path, notice: "イベントが更新されました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path, notice: "イベントを削除しました"
  end

  def show_public
    # 誰でも閲覧可能
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def authorize_admin!
    redirect_to root_path, alert: "権限がありません" unless current_user.admin?
  end

  def event_params
    params.require(:event).permit(:title, :body, :event_date, :organizer_name, :target_department)
  end
end
