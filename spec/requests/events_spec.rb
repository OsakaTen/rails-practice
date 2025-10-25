require 'rails_helper'

RSpec.describe "Users", type: :request do
  let!(:user) { 
    User.create!(
      email: "test@example.com", 
      password: "password", 
      first_name: "太郎", 
      last_name: "テスト"
      ) 
    }

  describe "ログイン" do
    context "正しいメール・パスワードの場合" do
      it "ログインできる" do
        post user_session_path, params: { 
          user: { email: user.email, password: "password" } 
        }
        expect(response).to redirect_to(events_path) 
        # Deviseのデフォルトリダイレクト先
      end
    end

    context "間違ったパスワードだとログインできない" do
      it "ログインに失敗する" do
        post user_session_path, params: { 
          user: { email: user.email, password: "wrong" } 
        }
        # Turbo対応なのでステータス422で返ってくる AI
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "ログアウト" do
    it "ログアウトできる" do
      sign_in user
      delete destroy_user_session_path
      expect(response).to redirect_to(root_path)
    end
  end
end