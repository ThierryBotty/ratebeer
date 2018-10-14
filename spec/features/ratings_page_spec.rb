require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryBot.create :beer, name: "iso 3", brewery: brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery: brewery }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq("15.0")
  end
end

describe "when many ratings are given" do
  let!(:user) { FactoryBot.create :user }

  before :each do
    schlenkerla = FactoryBot.create :brewery, name: 'Schlenkerla'
    rauchbier = FactoryBot.create :style, name: 'Rauchbier'
    create_beer_with_rating({ user: user, style: rauchbier, brewery: schlenkerla }, 20)
    create_beer_with_rating({ user: user }, 10)
    user2 = FactoryBot.create :user, username: 'Arto'
    create_beers_with_many_ratings({ user: user2 }, 7, 9, 15)
  end

  it "all and the count are shown at ratings_page" do
    visit ratings_path
    expect(page).to have_content 'anonymous 10 by Pekka'
    expect(page).to have_content 'anonymous 20 by Pekka'
    expect(page).to have_content 'anonymous 7 by Arto'
    expect(page).to have_content 'anonymous 9 by Arto'
    expect(page).to have_content 'anonymous 15 by Arto'
  end

  it "only users own ratings are shown at user page" do
    visit user_path(user)
    expect(page).to have_content 'anonymous 10'
    expect(page).to have_content 'anonymous 20'
    expect(page).not_to have_content 'anonymous 7'
  end

  it "when user removes a rating, it is deleted from database" do
    sign_in( username: 'Pekka', password: 'Foobar1')
    visit user_path(user)

    # etsitään sivun kaikista linkeistä ensimmäinen jonka teksti on delete
    delete_link = all('a').select{ |l| l.text=='delete' }.first

    expect{
      delete_link.click
    }.to change{Rating.count}.by(-1)
  end

  # it "favorite style and brewery are shown at users page" do
  #   visit user_path(user)
  #   expect(page).to have_content 'Favorite style: Rauchbier'
  #   expect(page).to have_content 'Favorite brewery: Schlenkerla'
  # end
end
