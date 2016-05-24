# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Profile.create!(name:  "Example Profile",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
	     admin: true,
	     activated: true,
	     activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  Profile.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
	       activated: true,
	       activated_at: Time.zone.now)
end

profiles = Profile.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  profiles.each { |profile| profile.posts.create!(content: content) }
end

profiles = Profile.all
profile = profiles.first
following = profiles[2..50]
followers = profiles[3..40]
following.each { |followed| profile.follow(followed) }
followers.each { |follower| follower.follow(profile) }
