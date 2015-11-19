require 'rails_helper'

RSpec.describe 'Create navigator page' do
  scenario 'renders the page', js: true do
    visit '/'
    assert_equal 200, page.status_code
    expect(page).to have_content 'Here you can generate a visual interface'
  end
end
