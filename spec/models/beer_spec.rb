require 'rails_helper'

RSpec.describe Beer, type: :model do

  describe "with a proper beer" do
    let(:test_brewery) { Brewery.create name: "test", year: 2000 }
    let(:test_beer) { Beer.create name: "santeri olut", style: "teststyle", brewery: test_brewery }
    let(:test_beer2) { Beer.create name: "", style: "teststyle", brewery: test_brewery }
    let(:test_beer3) { Beer.create name: "koliif", style: "", brewery: test_brewery }

    it "is saved" do
      expect(test_beer).to be_valid
      expect(Beer.count).to eq(1)
      expect(test_beer2).to_not be_valid
      expect(test_beer3).to_not be_valid
      expect(Beer.count).to eq(1)
    end
  end
end
