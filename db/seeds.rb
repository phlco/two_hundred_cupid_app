# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.destroy_all
Message.destroy_all

u1 = User.create({
  email: "a@example.com",
  password: "abcd1234",
  password_confirmation: "abcd1234"
})

u2 = User.create({
  email: "b@example.com",
  password: "abcd1234",
  password_confirmation: "abcd1234"
})

m1 = Message.create({
  sender: u1,
  receiver: u2,
  body: "Hi"
})

m2 = Message.create({
  sender: u2,
  receiver: u1,
  body: "Nice to meet you"
})
