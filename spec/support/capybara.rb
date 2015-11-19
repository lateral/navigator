require 'webmock/rspec'
require 'capybara/rspec'
require 'capybara/poltergeist'

WebMock.disable_net_connect! allow_localhost: true

Capybara.javascript_driver = :poltergeist
Capybara.automatic_reload = true

module CapybaraHelper
  def root_url
    "http://#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}/"
  end

  # From: http://theadmin.org/articles/test-http-basic-authentication-in-rails/
  def basic_auth(name, password)
    if page.driver.respond_to?(:basic_auth)
      page.driver.basic_auth(name, password)
    elsif page.driver.respond_to?(:basic_authorize)
      page.driver.basic_authorize(name, password)
    elsif page.driver.respond_to?(:browser) && page.driver.browser.respond_to?(:basic_authorize)
      page.driver.browser.basic_authorize(name, password)
    else
      raise "I don't know how to log in!"
    end
  end
end

RSpec.configure do |config|
  # Capybara (http://stackoverflow.com/a/15148622)
  config.include Capybara::DSL
  config.include CapybaraHelper, type: :feature
end
