require 'rails_helper'

include Helpers

describe "Beers page" do
  before :each do
    FactoryBot.create :user
    FactoryBot.create :brewery
  end

  describe "can add a beer" do
    it "can be added if name is valid" do
      sign_in(username: "Pekka", password: "Foobar1")
      visit new_beer_path
      fill_in('beer_name', with: 'kalja')

      expect{
        click_button('Create Beer')
      }.to change{Beer.count}.by(1)

    end

    it "can't add a beer without a name" do
      sign_in(username: "Pekka", password: "Foobar1")
      visit new_beer_path
      fill_in('beer_name', with: '')

      expect{
        click_button('Create Beer')
      }.to change{Beer.count}.by(0)
      expect(page).to have_content "Name can't be blank"
    end
  end
end
