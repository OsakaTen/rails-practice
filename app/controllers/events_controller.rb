class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, only: [:show_public]

  def index
    @events = current_user.events.order(created_at: :desc)
  end

  def show; end

  def edit; end

  def create
    @event = current_user.events.build(event_params)
    @event.organizer_name = current_user.full_name if @event.organizer_name.blank?

    if @event.save
      redirect_to @event, notice: 'イベントが正常に作成されました。'
    else
      render :new
    end
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: 'イベントが正常に更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @event.destroy
    redirect_to events_url, notice: 'イベントが正常に削除されました。'
  end

  private

  def set_event
    @event = current_user.events.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :event_date, :organizer_name, :target_departments)
  end
end
