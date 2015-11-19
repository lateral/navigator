# Add your own tasks in files placed in lib/tasks ending in .rake, for example
# lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

desc 'Install navigator dependencies'
task install: :environment do
  sh('npm install')
  sh('bundle install')
end

desc 'Run gulp to build the assets'
task gulp: :environment do
  sh('gulp build --release')
end
