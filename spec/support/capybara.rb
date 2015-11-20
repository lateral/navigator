require 'webmock/rspec'
require 'capybara/rspec'
require 'capybara/poltergeist'

WebMock.disable_net_connect! allow_localhost: true

Capybara.javascript_driver = :poltergeist
Capybara.automatic_reload = true
Capybara.default_selector = :css

module CapybaraHelper
  def root_url
    "http://#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}/"
  end
end

RSpec.configure do |config|
  # Capybara (http://stackoverflow.com/a/15148622)
  config.include Capybara::DSL
  config.include CapybaraHelper, type: :feature
end
