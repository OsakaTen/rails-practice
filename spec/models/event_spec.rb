# spec/models/event_spec.rb
require 'rails_helper'

RSpec.describe Event, type: :model do
  # EventモデルがUserと関連付いているので変更
  let(:user) do
    User.create!(
      email: "test@example.com",
      password: "password",
      first_name: "太郎",
      last_name: "テスト"
    )
  end

  let(:valid_attributes) do
    {
      title: "テストイベント",
      event_date: Date.today,
      organizer_name: "主催者",
      target_departments: "全社",
      description: "テスト用のイベント説明です",
      user: user
    }
  end

  describe 'バリデーション' do
    context '全ての属性が有効な場合' do
      it "有効であること" do
        event = Event.new(valid_attributes)
        expect(event).to be_valid
      end
    end

    describe 'title' do 
      context 'nilの場合' do
        it '無効であること' do
          event = Event.new(valid_attributes.merge(title: nil))
          event.valid?
          expect(event.errors[:title]).to include("can't be blank")
        end
      end

      context '空文字の場合' do
        it '無効であること' do
          event = Event.new(valid_attributes.merge(title: ""))
          event.valid?
          expect(event.errors[:title]).to include("can't be blank")
        end
      end

      context '空白のみの場合' do
        it '無効であること' do
          event = Event.new(valid_attributes.merge(title: "   "))
          event.valid?
          expect(event.errors[:title]).to include("can't be blank")
        end
      end

      context '有効な値の場合' do
        it '登録できること' do
          event = Event.new(valid_attributes.merge(title: "新しいイベント"))
          expect(event).to be_valid
        end
      end
    end

    describe 'description' do #説明
      # 下2つは境界値テスト
      context '5000文字の場合' do
        it '有効であること' do
          event = Event.new(valid_attributes.merge(description: "あ" * 5000))
          expect(event).to be_valid
        end
      end

      context '5001文字の場合' do
        it '無効であること' do
          event = Event.new(valid_attributes.merge(description: "あ" * 5001))
          event.valid?
          expect(event.errors[:description]).to include("is too long (maximum is 5000 characters)")
        end
      end

      context '10000文字の場合' do
        it '無効であること' do
          event = Event.new(valid_attributes.merge(description: "あ" * 10000))
          event.valid?
          expect(event.errors[:description]).to include("is too long (maximum is 5000 characters)")
        end
      end

      context 'nilの場合' do
        it '有効であること（descriptionは任意項目）' do
          event = Event.new(valid_attributes.merge(description: nil))
          expect(event).to be_valid
        end
      end

      context '空文字の場合' do
        it '有効であること' do
          event = Event.new(valid_attributes.merge(description: ""))
          expect(event).to be_valid
        end
      end

      context '空白のみの場合' do
        it '有効であること' do
          event = Event.new(valid_attributes.merge(description: "   "))
          expect(event).to be_valid
        end
      end
    end

    describe 'event_date' do  #主催日
      context '今日の日付の場合' do
        it '有効であること' do
          event = Event.new(valid_attributes.merge(event_date: Date.today))
          expect(event).to be_valid
        end
      end

      context '未来の日付の場合' do
        it '有効であること' do
          event = Event.new(valid_attributes.merge(event_date: Date.tomorrow))
          expect(event).to be_valid
        end
      end

      context '過去の日付の場合' do
        it '登録できること' do
          event = Event.new(valid_attributes.merge(event_date: Date.yesterday))
          expect(event).to be_valid
        end
      end

      context 'nilの場合' do
        it '無効であること' do
          event = Event.new(valid_attributes.merge(event_date: nil))
          event.valid?
          expect(event.errors[:event_date]).to include("can't be blank")
        end
      end
    end

    describe 'organizer_name' do #主催者名
      context 'nilの場合' do
        it '無効であること' do
          event = Event.new(valid_attributes.merge(organizer_name: nil))
          event.valid?
          expect(event.errors[:organizer_name]).to include("can't be blank")
      end

      context '空文字の場合' do
        it '無効であること' do
          event = Event.new(valid_attributes.merge(organizer_name: ""))
          event.valid?
          expect(event.errors[:organizer_name]).to include("can't be blank")
        end
      end

      context '空白のみの場合' do
        it '無効であること' do
          event = Event.new(valid_attributes.merge(organizer_name: "   "))
          event.valid?
          expect(event.errors[:organizer_name]).to include("can't be blank")
        end
      end

      context '有効な値の場合' do
        it '登録できること' do
          event = Event.new(valid_attributes.merge(organizer_name: "新しい主催者"))
          expect(event).to be_valid
        end
      end
    end

    describe 'target_departments' do #部署
      context 'nilの場合' do
        it '無効であること' do
          event = Event.new(valid_attributes.merge(target_departments: nil))
          event.valid?
          expect(event.errors[:target_departments]).to include("can't be blank")
        end
      end

      context '空文字の場合' do
        it '無効であること' do
          event = Event.new(valid_attributes.merge(target_departments: ""))
          event.valid?
          expect(event.errors[:target_departments]).to include("can't be blank")
        end
      end

      context '空白のみの場合' do
        it '無効であること' do
          event = Event.new(valid_attributes.merge(target_departments: "   "))
          event.valid?
          expect(event.errors[:target_departments]).to include("can't be blank")
        end
      end

      context '有効な値の場合' do
        it '登録できること' do
          event = Event.new(valid_attributes.merge(target_departments: "営業部"))
          expect(event).to be_valid
        end
      end
    end
  end

  describe 'user_id (関連付け)' do
      context 'userが存在する場合' do
        it '有効であること' do
          event = Event.new(valid_attributes)
          expect(event).to be_valid
        end
      end

      context 'userが存在しない場合' do
        it '無効であること' do
          event = Event.new(valid_attributes.merge(user: nil))
          event.valid?
          expect(event.errors[:user]).to include("must exist")
        end
      end
    end
  end

  describe 'CRUD機能' do
    it 'レコードを作成できること' do
      event = Event.create(valid_attributes)
      expect(Event.find_by(title: "テストイベント")).to eq(event)
    end

    it 'レコードを読み取れること（Read）' do
      event = Event.create!(valid_attributes)
      found = Event.find(event.id)
      expect(found.title).to eq("テストイベント")
    end

    it 'レコードを更新できること（Update）' do
      event = Event.create!(valid_attributes)
      event.update(title: "更新後イベント")
      expect(event.reload.title).to eq("更新後イベント")
    end

    it 'レコードを削除できること（Delete）' do
      event = Event.create!(valid_attributes)
      event.destroy
      expect(Event.exists?(event.id)).to be_falsey
    end
  end

  describe '関連付け' do
    it 'userに紐づいていること' do
      event = Event.create!(valid_attributes)
      expect(event.user).to eq(user)
    end

    it 'userが削除されるとeventも削除されること（dependent: :destroyの場合）' do
      event = Event.create!(valid_attributes)
      expect { user.destroy }.to change { Event.count }.by(-1)
    end
  end
end
