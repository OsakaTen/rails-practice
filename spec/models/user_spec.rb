require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) do
    User.new(
      email: "test@example.com",
      password: "password",
      first_name: "太郎",
      last_name: "テスト"
    )
  end

  describe "ユーザー登録のバリデーション（正しく保存できるか）" do
    it "全ての項目が正しく入力されていれば有効であること" do
      expect(user).to be_valid
    end

    it "メールアドレスがない場合、無効であること" do
      user.email = nil
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "パスワードがない場合、無効であること" do
      user.password = nil
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end

    it "重複したメールアドレスは無効であること" do
      User.create!(
        email: "duplicate@example.com",
        password: "password",
        first_name: "一郎",
        last_name: "テスト"
      )
      user = User.new(
        email: "duplicate@example.com",
        password: "password2",
        first_name: "二郎",
        last_name: "テスト"
      )
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end

    it "first_name がない場合、無効であること" do
      user.first_name = nil
      expect(user).not_to be_valid
      expect(user.errors[:first_name]).to include("can't be blank")
    end

    it "last_name がない場合、無効であること" do
      user.last_name = nil
      expect(user).not_to be_valid
      expect(user.errors[:last_name]).to include("can't be blank")
    end
  end

  describe "Userモデルのインスタンスメソッド（動作確認）" do
    it "#full_name が first_name と last_name を結合して返すこと" do
      user = User.new(
        first_name: "太郎",
        last_name: "テスト"
      )
      expect(user.full_name).to eq("テスト 太郎")
    end

    it "#full_name がどちらも存在しない場合は空文字を返すこと" do
      user = User.new
      expect(user.full_name).to eq("")
    end
  end
end
