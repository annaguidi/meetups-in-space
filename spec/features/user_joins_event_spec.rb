require 'spec_helper'

feature "User sees a list of joined members and join an event" do
  let(:user1) do
    User.create(
      provider: "github",
      uid: "2",
      username: "nate",
      email: "nmg214@gmail.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
  end

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
  scenario "user sees list and views event details" do
    user
    user1
    event2
    event1
    member

    visit '/'
    click_link 'movie monday'

    expect(page).to have_content "Attending:"
  end

end

feature "User joins an event" do
  let(:user1) do
    User.create(
      provider: "github",
      uid: "2",
      username: "nate",
      email: "nmg214@gmail.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
  end

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



  scenario "user joins an event" do
    user
    user1
    event2
    event1
    member
    visit '/'
    sign_in_as user1
    click_link 'movie monday'

    click_button 'Join'

    expect(page).to have_content("nate", count: 2)

  end

  scenario "user tries to join an event they have already joined" do
    user
    user1
    event2
    event1
    member
    visit '/'
    sign_in_as user1
    click_link 'movie monday'

    click_button 'Join'

    expect(page).to have_content("nate", count: 2)
    expect(page).to_not have_button("Join")


  end

  scenario "user tries to join an event" do
    user
    user1
    event2
    event1
    member
    visit '/'
    click_link 'movie monday'

    click_button 'Join'

    expect(page).to have_content("You need to be signed in")

  end




end
