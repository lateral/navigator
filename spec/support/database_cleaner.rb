require 'database_cleaner'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation, except: %w(public.schema_migrations), reset_ids: true)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :truncation, { reset_ids: true }
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
