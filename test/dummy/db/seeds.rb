# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Tag.create(name: "apple")
Tag.create(name: "google")
Tag.create(name: "banana")

tags = Tag.all.to_a

(1..100).each do |i|
  User.create(first_name: "##{i}", last_name: "Dummy#{i}", gender: 'male', email: "dummy#{i}@dummy.com", birthday: Date.today)
end
(1..100).each do |i|
  article = Article.create(title: 'This is a title', content: 'This is a content')
  article.tags = tags
  article.save
end
