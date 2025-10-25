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
    it "正しいメール・パスワードでログインできる" do
      post user_session_path, params: { 
        user: { email: user.email, password: "password" } 
      }
      expect(response).to redirect_to(events_path) 
      # Deviseのデフォルトリダイレクト先
    end

    it "間違ったパスワードだとログインできない" do
      post user_session_path, params: { 
        user: { email: user.email, password: "wrong" } 
      }
      expect(response).to redirect_to(new_user_session_path) # ログインページにリダイレクト
      follow_redirect!
      expect(response.body).to include("Invalid Email or password")
    end
  end
end
