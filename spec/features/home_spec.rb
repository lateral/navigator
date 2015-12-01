require 'rails_helper'

RSpec.describe 'Home page' do
  before(:each) do
    # Mock the Lateral API with valid key of 'test'
    # Sets @results and @documents instance variables
    init_fake_lateral!
    @creds = FactoryGirl.create(:credentials, key: 'test', name: 'Max')
  end

  scenario 'renders the page if not password protectd', js: true do
    visit "/#{@creds.url_hash}/#{@creds.slug}"
    wait_for_ajax
    assert_equal 200, page.status_code
    expect(page).to have_content 'MAX NAVIGATOR'
  end

  scenario 'gets past auth if password protected', js: true do
    creds = FactoryGirl.create(:credentials, key: 'test', name: 'Max', password_protected: true,
                                             username: 'max', password: 'password')
    page.driver.basic_authorize creds.username, creds.password
    visit "/#{creds.url_hash}/#{creds.slug}"
    wait_for_ajax
    assert_equal 200, page.status_code
    expect(page).to have_content 'MAX NAVIGATOR'
  end

  scenario 'renders five results', js: true do
    visit "/#{@creds.url_hash}/#{@creds.slug}"
    wait_for_ajax
    expect(page).to have_content @documents.last[:meta][:title]
    expect(page).to have_selector('.result', count: 5)
  end

  scenario 'clicking a random document gets results', js: true do
    visit "/#{@creds.url_hash}/#{@creds.slug}"
    wait_for_ajax
    page.all(:css, "a[data-id='#{@documents.first[:id]}']")[0].click
    wait_for_ajax
    expect(page).to have_content @documents.first[:meta][:title]
    @results.each do |result|
      expect(page).to have_content result[:meta][:title]
    end
  end
end
