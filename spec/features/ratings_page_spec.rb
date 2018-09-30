require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryBot.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  describe "Ratings are shown" do
    it "show all ratings" do
      visit ratings_path
      @ratings = Rating.all
      expect(page).to have_content "Number of ratings: #{@ratings.count}"
      @ratings.each do |r|
        expect(page).to have_content "#{r.beer.name} #{r.score}"
      end
    end
  end
end
