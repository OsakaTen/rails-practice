# 管理用ユーザーを作成
admin_user = User.find_or_create_by(email: 'admin@company.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.first_name = '管理'
  user.last_name = '太郎'
  user.role = 'admin'
end

# サンプルユーザー作成
sample_user = User.find_or_create_by(email: 'masuda@company.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.first_name = '花子'
  user.last_name = '益田'
  user.role = 'staff'
end

puts "ユーザーが作成されました："
puts "管理者: admin@company.com / password123"
puts "一般: masuda@company.com / password123"