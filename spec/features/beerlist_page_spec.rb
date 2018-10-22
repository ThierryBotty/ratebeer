require 'rails_helper'

describe "Beerlist page" do
  before :all do
    Capybara.register_driver :selenium do |app|
      capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
        chromeOptions: { args: ['headless', 'disable-gpu']  }
      )

      Capybara::Selenium::Driver.new app,
        browser: :chrome,
        desired_capabilities: capabilities
    end
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  before :each do
    @brewery1 = FactoryBot.create(:brewery, name:"Koff")
    @brewery2 = FactoryBot.create(:brewery, name:"Schlenkerla")
    @brewery3 = FactoryBot.create(:brewery, name:"Ayinger")
    @style1 = Style.create name:"Lager"
    @style2 = Style.create name:"Rauchbier"
    @style3 = Style.create name:"Weizen"
    @beer1 = FactoryBot.create(:beer, name:"Nikolai", brewery: @brewery1, style:@style1)
    @beer2 = FactoryBot.create(:beer, name:"Fastenbier", brewery:@brewery2, style:@style2)
    @beer3 = FactoryBot.create(:beer, name:"Lechte Weisse", brewery:@brewery3, style:@style3)
  end

  it "shows a known beer", js: true do
    visit beerlist_path
    find('table').find('tr:nth-child(2)')
    save_and_open_page
    expect(page).to have_content "Nikolai"
  end

  it "has beers ordered alphabetically", js: true do
    visit beerlist_path
    expect(page.find('table').find('tr:nth-child(2)')).to have_content 'Fastenbier'
    expect(page.find('table').find('tr:nth-child(3)')).to have_content 'Lechte Weisse'
    expect(page.find('table').find('tr:nth-child(4)')).to have_content 'Nikolai'
  end

  it "has styles ordered alphabetically", js: true do
    visit beerlist_path
    find('#style').click
    expect(page.find('table').find('tr:nth-child(2)')).to have_content 'Lager'
    expect(page.find('table').find('tr:nth-child(3)')).to have_content 'Rauchbier'
    expect(page.find('table').find('tr:nth-child(4)')).to have_content 'Weizen'
  end

  it "has breweries ordered alphabetically", js: true do
    visit beerlist_path
    find('#brewery').click
    expect(page.find('table').find('tr:nth-child(2)')).to have_content 'Ayinger'
    expect(page.find('table').find('tr:nth-child(3)')).to have_content 'Koff'
    expect(page.find('table').find('tr:nth-child(4)')).to have_content 'Schlenkerla'
  end
end
