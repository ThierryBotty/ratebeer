require 'rails_helper'

include Helpers
include ActionView::Helpers::TextHelper

describe "User" do
  let!(:user) { FactoryBot.create :user }
  before :each do
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username: "Pekka", password: "Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username: "Pekka", password: "wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with: 'Brian')
    fill_in('user_password', with: 'Secret55')
    fill_in('user_password_confirmation', with: 'Secret55')

    expect{
      click_button('Create User')
    }.to change{ User.count }.by(1)
  end

  describe "user ratings" do
    let(:user1){ FactoryBot.create :user, username: "toinne" }

    it "should not have any ratings" do
      visit user_path(user)
      expect(page).to have_content "user has not rated any beers!"
    end

    it "should have one rating" do
      create_beer_with_rating({ user: user }, 11)
      visit user_path(user)
      expect(page).to have_content "Has made 1 rating"
    end

    it "should have some ratings" do
      create_beers_with_many_ratings({ user: user }, 10, 15, 9)
      create_beers_with_many_ratings({ user: user1 }, 11, 25, 19)
      visit user_path(user)
      @user = user
      expect(page).to have_content "Has made 3 ratings"
      @user.ratings.each do |r|
        expect(page).to have_content "#{r.beer.name} #{r.score}"
      end
    end
  end

  describe "ratings are removed from database" do
    it "remove rating" do
      FactoryBot.create :rating, user: user
      sign_in(username: "Pekka", password: "Foobar1")
      visit user_path(user)
      expect{
        page.find_link(href: '/ratings/1').click
      }.to change{ Rating.count }.by(-1)
    end
  end
end
