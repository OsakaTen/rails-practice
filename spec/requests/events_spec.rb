require 'rails_helper'

RSpec.describe "Events", type: :request do
  let!(:user) { 
    User.create!(
      email: "test@example.com", 
      password: "password", 
      first_name: "太郎", 
      last_name: "テスト"
    ) 
  }

  let!(:event) { 
    Event.create!(
      title: "テストイベント",
      description: "これはテスト用のイベントです",
      event_date: Date.today,
      organizer_name: "テスト主催者",              # ✅ 追加
      target_departments: "全学部対象",            # ✅ 追加
      user: user
    )
  }

  describe "GET /events" do
    it "イベント一覧ページが表示される" do
      get events_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("テストイベント")
    end
  end

  describe "GET /events/:id" do
    it "イベント詳細ページが表示される" do
      get event_path(event)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("これはテスト用のイベントです")
    end
  end

  describe "POST /events" do
    context "ログインしている場合" do
      before { sign_in user }

      it "新しいイベントを作成できる" do
        expect {
          post events_path, params: { 
            event: { 
              title: "新イベント", 
              description: "詳細テスト", 
              event_date: Date.tomorrow,
              organizer_name: "新しい主催者",      # ✅ 追加
              target_departments: "経済学部"        # ✅ 追加
            }
          }
        }.to change(Event, :count).by(1)

        expect(response).to redirect_to(event_path(Event.last))
      end
    end

    context "未ログインの場合" do
      it "ログインページにリダイレクトされる" do
        post events_path, params: { 
          event: { 
            title: "新イベント", 
            description: "詳細テスト", 
            event_date: Date.tomorrow,
            organizer_name: "主催者",            # ✅ 追加
            target_departments: "経営学部"        # ✅ 追加
          }
        }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE /events/:id" do
    context "ログインしている場合" do
      before { sign_in user }

      it "イベントを削除できる" do
        expect {
          delete event_path(event)
        }.to change(Event, :count).by(-1)
        expect(response).to redirect_to(events_path)
      end
    end

    context "未ログインの場合" do
      it "ログインページにリダイレクトされる" do
        delete event_path(event)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end