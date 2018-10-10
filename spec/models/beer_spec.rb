require 'rails_helper'

RSpec.describe Beer, type: :model do
  let(:brewery) { Brewery.create name: 'crapbrau', year: 1900 }
  let(:lager) { Style.create name: 'lager' }

  it "is created with valid input" do
    beer = Beer.create name: 'crap', style: lager, brewery: brewery
    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "is not saved without name" do
    beer = Beer.create style: lager, brewery: brewery

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved without style" do
    beer = Beer.create name: 'crap', brewery: brewery

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
