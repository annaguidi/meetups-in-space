require 'spec_helper'

feature "User sees members that belong to an event" do
  let(:user) do
    User.create(
      provider: "github",
      uid: "1",
      username: "jarlax1",
      email: "jarlax1@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
  end


  scenario "successfully adds an event" do
    user

    visit '/'
    sign_in_as user

    expect(page).to have_content "You're now signed in as #{user.username}!"


    visit '/meetups/new'
    fill_in('Name:', :with => 'Party')
    fill_in('Description:', :with => 'Rage')
    fill_in('Location:', :with => 'bla blabla')
    click_button "Submit"
    expect(page).to have_content "Party"
  end

  scenario "unsuccessfully tries to add an event" do
    user



    visit '/meetups/new'
    fill_in('Name:', :with => 'Something')
    fill_in('Description:', :with => 'Something else')
    fill_in('Location:', :with => 'blablablabla')
    click_button "Submit"
    expect(page).to have_content "You need to be signed in in order to create an event."
  end

end
