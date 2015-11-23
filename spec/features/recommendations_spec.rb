require 'rails_helper'

RSpec.describe 'Recommendations page' do
  before(:each) do
    # Mock the Lateral API with valid key of 'test'
    # Sets @results and @documents instance variables
    init_fake_lateral!
    @creds = FactoryGirl.create(:credentials, key: 'test', name: 'Max')
  end

  scenario 'displays results', js: true do
    visit "/#{@creds.url_hash}/#{@creds.slug}/results/#{@documents.first[:id]}"
    wait_for_ajax
    expect(page).to have_content @documents.first[:meta][:title]
    @results.each do |result|
      expect(page).to have_content result[:meta][:title]
    end
  end

  scenario 'allows sorting if date is present', js: true do
    visit "/#{@creds.url_hash}/#{@creds.slug}/results/#{@documents.first[:id]}"
    wait_for_ajax
    expect(page).to have_content 'SORT BY'
  end

  scenario 'disables sorting if date is not present', js: true do
    @documents.first[:meta].delete(:date)
    visit "/#{@creds.url_hash}/#{@creds.slug}/results/#{@documents.first[:id]}"
    wait_for_ajax
    expect(page).to_not have_content 'SORT BY'
  end
end
