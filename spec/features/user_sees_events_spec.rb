require 'spec_helper'

feature "User sees list of events" do
  let(:user) do
    User.create(
      provider: "github",
      uid: "1",
      username: "jarlax1",
      email: "jarlax1@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
  end

  let(:event1) do
    Event.create(
    name: 'movie monday',
    description: 'watch movies',
    location: 'movie theatre'

    )
  end

  let(:event2) do
    Event.create(
    name: 'ice cream super bowl',
    description: 'flat fee for sooooo much ice cream',
    location: 'prudential'

    )
  end


  let(:member) do
    Member.create(
    user_id: user.id,
    event_id: event1.id,
    creator: true
    )
  end

  scenario "successfully views list" do
    user
    event2
    member

    visit '/'
    expect(page).to have_content "ice cream"
  end

  scenario "list is in alphabetical order" do
    user
    event1
    event2
    member

    visit '/'
    ("ice cream").should appear_before("movie")
  end


end
