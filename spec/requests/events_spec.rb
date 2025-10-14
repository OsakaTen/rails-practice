# spec/requests/events_spec.rb
require 'rails_helper'

RSpec.describe "Events", type: :request do
  let(:user) {
    User.create!(
      email: "test@example.com",
      password: "password",
      first_name: "太郎",
      last_name: "テスト"
    )
  }

  before do
    sign_in user # Deviseのログインヘルパー
  end

  describe "GET /events" do
    it "イベント一覧が表示される" do
      get events_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /events" do
    it "有効なデータでイベントを作成できる" do
      expect {
        post events_path, params: {
          event: {
            title: "新イベント",
            event_date: Date.today,
            organizer_name: "主催者",
            description: "説明文",
            target_departments: "全学年",
            user_id: user.id
          }
        }
      }.to change(Event, :count).by(1)
      expect(response).to redirect_to(event_path(Event.last))
    end

    it "無効なデータでは作成できない" do
      expect {
        post events_path, params: {
          event: {
            title: "",
            event_date: nil,
            organizer_name: "",
            description: "",
            target_departments: "",
            user_id: user.id
          }
        }
      }.not_to change(Event, :count)
    end
  end
end
