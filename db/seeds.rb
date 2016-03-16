# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Example:
#
#   Person.create(first_name: 'Eric', last_name: 'Kelly')
require "faker"

admin = User.create(
provider: 'ATT',
uid: '123456',
username: 'admin',
email: 'nmg214@gmail.com',
avatar_url: 'http://imgur.com/gallery/aQEGq'
)
i = 1
10.times do
  event = Event.create(
  name: Faker::Hacker.noun,
  description: Faker::Hacker.say_something_smart,
  location: Faker::Address.city
  )

  Member.create(
  user_id: admin.id,
  creator: true,
  event: event
  )
  i += 1
end
