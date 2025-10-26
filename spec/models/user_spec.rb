require 'rails_helper'

RSpec.describe User, type: :model do
  # テストデータを一箇所に集約して再利用できるようにするために変更
  let(:valid_attributes) do
    {
      email: "test@example.com",
      password: "password123",
      first_name: "太郎",
      last_name: "テスト"
    }
  end

  describe "バリデーション" do
    context "全ての属性が有効な場合" do
      it "有効であること" do
        expect(User.new(valid_attributes)).to be_valid
      end
    end

    describe "email" do
      context 'nilの場合' do
        it "無効であること" do
          user = User.new(valid_attributes.merge(email: nil))
          user.valid?
          expect(user.errors[:email]).to include("can't be blank")
        end
      end

      context '空文字の場合' do
        it '無効であること' do
          user = User.new(valid_attributes.merge(email: ""))
          user.valid?
          expect(user.errors[:email]).to include("can't be blank")
        end
      end

      context '空白のみの場合' do
        it "無効であること" do
          user = User.new(valid_attributes.merge(email: "   "))
          user.valid?
          expect(user.errors[:email]).to include("can't be blank")
        end
      end

      context '形式が正しい場合' do
        it "有効であること" do
          user = User.new(valid_attributes.merge(email: "valid@example.com"))
          expect(user).to be_valid
        end
      end

      context '形式が不正な場合' do
        it "無効であること" do
          invalid_emails = ["invalid", "invalid@", "@example.com", "user@example"]
          invalid_emails.each do |email|
            user = User.new(valid_attributes.merge(email: email))
            expect(user).not_to be_valid, "#{email} は無効な形式です"
          end
        end
      end

      context '重複したメールアドレスの場合' do
        it "無効であること" do
          User.create!(valid_attributes)
          dup_user = User.new(valid_attributes.merge(password: "anotherpass"))
          dup_user.valid?
          expect(dup_user.errors[:email]).to include("has already been taken")
        end
      end

      context '大文字小文字を区別せず重複チェックする場合' do
        it '無効であること' do
          User.create!(valid_attributes)
          dup_user = User.new(valid_attributes.merge(email: "TEST@EXAMPLE.COM", password: "anotherpass"))
          dup_user.valid?
          expect(dup_user.errors[:email]).to include("has already been taken")
        end
      end
    end

    describe "password" do
      context 'nilの場合' do
        it "無効であること" do
          user = User.new(valid_attributes.merge(password: nil))
          user.valid?
          expect(user.errors[:password]).to include("can't be blank")
        end
      end

      context '7文字の場合' do
        it "無効であること" do
          user = User.new(valid_attributes.merge(password: "1234567"))
          user.valid?
          expect(user.errors[:password]).to include("is too short (minimum is 8 characters)")
        end
      end

      context '8文字の場合' do
        it '有効であること' do
          user = User.new(valid_attributes.merge(password: "12345678"))
          expect(user).to be_valid
        end
      end

      context '8文字以上の場合' do
        it '有効であること' do
          user = User.new(valid_attributes.merge(password: "password123456"))
          expect(user).to be_valid
        end
      end
    end

    describe "first_name と last_name" do
      it "どちらも必須であること" do
        user1 = User.new(valid_attributes.merge(first_name: nil))
        user2 = User.new(valid_attributes.merge(last_name: nil))
        user1.valid?
        user2.valid?
        expect(user1.errors[:first_name]).to include("can't be blank")
        expect(user2.errors[:last_name]).to include("can't be blank")
      end

      it "空白のみの場合は無効であること" do
        user1 = User.new(valid_attributes.merge(first_name: "   "))
        user2 = User.new(valid_attributes.merge(last_name: "   "))
        user1.valid?
        user2.valid?
        expect(user1.errors[:first_name]).to include("can't be blank")
        expect(user2.errors[:last_name]).to include("can't be blank")
      end
    end
  end

  describe "#full_name" do
    context 'first_nameとlast_nameが両方存在する場合' do
      it "last_nameとfirst_nameをスペースで結合して返すこと" do
        user = User.new(valid_attributes)
        expect(user.full_name).to eq("テスト 太郎")
      end
    end

    it "どちらか一方が存在しない場合は存在する方を返すこと" do
      expect(User.new(first_name: "太郎").full_name).to eq("太郎")
      expect(User.new(last_name: "テスト").full_name).to eq("テスト")
    end

    it "両方nilの場合は空文字を返すこと" do
      expect(User.new(first_name: nil, last_name: nil).full_name).to eq("")
    end
  end
end