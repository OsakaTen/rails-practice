class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    @events = Event.all.order(event_date: :desc)
  end

  def show; end

  def new
    @event = current_user.events.new
  end

  def create
    @event = current_user.events.new(event_params)

    if @event.save
      redirect_to @event, notice: "イベント登録完了！"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    unless @event.user == current_user
      redirect_to events_path, alert: '他のユーザーのイベントは編集できません。'
    end
  end

  def update
    unless @event.user == current_user
      redirect_to events_path, alert: '他のユーザーのイベントは更新できません。'
      return
    end

    if @event.update(event_params)
      redirect_to @event, notice: 'イベントが更新されました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    unless @event.user == current_user
      redirect_to events_path, alert: '他のユーザーのイベントは削除できません。'
      return
    end

    @event.destroy
    redirect_to events_path, notice: 'イベントが削除されました。', status: :see_other
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(
      :title,
      :event_date,
      :organizer_name,
      :target_departments,
      :description
    )
  end
end
