gem 'foundation-rails'
gem 'friendly_id'
gem 'draper'

gem_group :test do
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'capybara-webkit'
  gem 'quiet_assets'
  gem 'factory_girl_rails'
end

gem_group :production do
  gem 'rails_12_factor'
  gem 'unicorn'
end

git :init
git add: "."
git commit: "-am 'Initial commit'"
