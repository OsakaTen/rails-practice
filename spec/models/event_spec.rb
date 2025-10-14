# spec/models/event_spec.rb
require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:user) {
    User.create!(
      email: "test@example.com",
      password: "password",
      first_name: "太郎",
      last_name: "テスト"
    )
  }

  it "有効なデータの場合、有効であること" do
    event = Event.new(
      title: "テストイベント",
      event_date: Date.today,
      organizer_name: "主催者",
      target_departments: "全社",
      description: "テスト用のイベント説明です",
      user: user
    )
    expect(event).to be_valid
  end

  it "タイトルがない場合、無効であること" do
    event = Event.new(
      title: nil, 
      event_date: Date.today, 
      organizer_name: "主催者", 
      description: "説明", 
      user: user
    )
    expect(event).not_to be_valid
  end

  it "説明が5000文字を超える場合、無効であること" do
    event = Event.new(
      title: "テスト", 
      event_date: Date.today, 
      organizer_name: "主催者", 
      description: "あ" * 5001, 
      user: user
    )
    expect(event).not_to be_valid
  end
end
