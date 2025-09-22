# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb
# 管理者ユーザーの作成
admin_user = User.find_or_create_by(email: 'admin@example.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.first_name = '管理'
  user.last_name = '太郎'
  user.role = 'admin'
end

puts "管理者ユーザーを作成しました: #{admin_user.email}"

# サンプルイベントの作成
sample_event = Event.find_or_create_by(title: '部署対抗ボードゲーム大会') do |event|
  event.description = '開発部と営業部の交流を目的とした懇親イベント。お菓子とドリンクを用意してお待ちしています！'
  event.event_date = 1.week.from_now.change(hour: 18, min: 0)  # 1週間後の18:00
  event.organizer_name = '益田花子'
  event.target_departments = '全社（特に開発・営業）'
  event.user = admin_user
end

puts "サンプルイベントを作成しました: #{sample_event.title}"
puts "公開URL: http://localhost:3000/public/events/#{sample_event.public_token}"