require 'rails_helper'

RSpec.describe 'Create navigator page' do
  before(:each) do
    # Mock the Lateral API with valid key of 'test'
    # Sets @results and @documents instance variables
    init_fake_lateral!
    @creds = FactoryGirl.create(:credentials, key: 'test', name: 'Max')
  end

  scenario 'renders the page', js: true do
    visit '/'
    expect(page).to have_content 'Here you can generate a visual interface'
  end

  scenario 'validates name is present', js: true do
    visit '/'
    fill_in 'key', with: 'key'
    find('#create').click
    expect(page).to have_content 'Name is blank'
  end

  scenario 'validates key is present', js: true do
    visit '/'
    fill_in 'name', with: 'name'
    find('#create').click
    expect(page).to have_content 'Key is blank'
  end

  scenario 'validates key is valid', js: true do
    visit '/'
    fill_in 'name', with: 'name'
    fill_in 'key', with: 'open'
    find('#create').click
    expect(page).to have_content 'Key is not valid'
  end

  scenario 'creates a working navigator', js: true do
    visit '/'
    fill_in 'name', with: 'name'
    fill_in 'key', with: 'test'
    find('#create').click
    expect(page).to have_content 'Navigator created!'
    visit find('.confirmation .url span').text
    wait_for_ajax
    expect(page).to have_content @documents.sample[:meta][:title]
    expect(page).to have_selector('.result', count: 5)
  end

  scenario 'creates a working navigator with password', js: true do
    visit '/'
    fill_in 'name', with: 'name'
    fill_in 'key', with: 'test'
    find('#password_protected').trigger('click')
    fill_in 'username', with: 'username'
    find('#create').click
    expect(page).to have_content 'Navigator created!'
    page.driver.basic_authorize 'username', find('.confirmation .password span').text
    visit find('.confirmation .url span').text
    wait_for_ajax
    expect(page).to have_content @documents.sample[:meta][:title]
    expect(page).to have_selector('.result', count: 5)
  end
end
