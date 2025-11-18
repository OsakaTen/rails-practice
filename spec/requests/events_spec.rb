require 'rails_helper'

RSpec.describe "Events", type: :request do
  # ==== テストデータ作成 ====
  let!(:user) do
    User.create!(
      email: "user@example.com",
      password: "password",
      first_name: "太郎",
      last_name: "テスト"
    )
  end

  let!(:other_user) do
    User.create!(
      email: "other@example.com",
      password: "password",
      first_name: "次郎",
      last_name: "他人"
    )
  end

  let!(:event) do
    Event.create!(
      title: "自分のイベント",
      description: "自分のイベント説明",
      event_date: Date.today,
      organizer_name: "自分の主催者",
      target_departments: "全学部対象",
      user: user
    )
  end

  let!(:other_event) do
    Event.create!(
      title: "他人のイベント",
      description: "他人のイベント説明",
      event_date: Date.today,
      organizer_name: "他人の主催者",
      target_departments: "経済学部",
      user: other_user
    )
  end

  # ==== 一覧・詳細 ====
  describe "GET /events" do
    it "イベント一覧ページが表示される" do
      get events_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("自分のイベント")
      expect(response.body).to include("他人のイベント")
    end
  end

  describe "GET /events/:id" do
    it "イベント詳細ページが表示される" do
      get event_path(event)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("自分のイベント説明")
    end

    it "他人のイベント詳細ページも表示される" do
      get event_path(other_event)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("他人のイベント説明")
    end
  end

  # ==== 新規作成 ====
  describe "POST /events" do
    context "ログインしている場合" do
      before { sign_in user }

      it "新しいイベントを作成できる" do
        expect {
          post events_path, params: {
            event: {
              title: "新イベント",
              description: "新しい説明",
              event_date: Date.tomorrow,
              organizer_name: "新しい主催者",
              target_departments: "法学部"
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
            description: "新しい説明",
            event_date: Date.tomorrow,
            organizer_name: "主催者",
            target_departments: "経営学部"
          }
        }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  # ==== 編集 ====
  describe "PATCH /events/:id" do
    context "自分のイベントの場合" do
      it "編集できる" do
        sign_in user
        patch event_path(event), params: { event: { title: "変更後タイトル" } }
        expect(response).to redirect_to(event_path(event))
        # リダイレクトを実際に“追跡”して次のページを開く という命令
        follow_redirect!
        expect(response.body).to include("イベントが更新されました")
      end
    end

    context "他人のイベントの場合" do
      it "編集できず一覧にリダイレクトされる" do
        sign_in user
        patch event_path(other_event), params: { event: { title: "不正変更" } }

        expect(response).to redirect_to(events_path)
        follow_redirect!
        expect(flash[:alert]).to eq("他のユーザーのイベントは更新できません。")
      end
    end
  end

  # ==== 削除 ====
  describe "DELETE /events/:id" do
    context "自分のイベントの場合" do
      it "削除できる" do
        sign_in user
        expect {
          delete event_path(event)
        }.to change(Event, :count).by(-1)

        expect(response).to redirect_to(events_path)
      end
    end

    context "他人のイベントの場合" do
      it "削除できず一覧にリダイレクトされる" do
        sign_in user
        expect {
          delete event_path(other_event)
        }.not_to change(Event, :count)

        expect(response).to redirect_to(events_path)
        # リダイレクトを実際に“追跡”して次のページを開く という命令
        follow_redirect!
        expect(flash[:alert]).to eq("他のユーザーのイベントは削除できません。")
      end
    end
  end
end
