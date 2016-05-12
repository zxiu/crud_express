# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

(1..10).each do |i|
  User.create(first_name: 'Z', last_name: 'Xiu', gender: 'male', email: 'zxiu@zxiu.com', birthday: Date.today)
end
(1..10).each do |i|
  Article.create(title: 'haha', content: 'What a gem')
end
