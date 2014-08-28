gem 'foundation-rails', '~> 5.3.3.0'
gem 'friendly_id', '~> 5.0.4'
gem 'draper', '~> 1.3.1'

gem_group :test do
  gem 'pry-rails', '~> 0.3.2'
  gem 'rspec-rails', '~> 3.0.2'
  gem 'database_cleaner', '~> 1.3.0'
  gem 'launchy', '~> 2.4.2'
  gem 'capybara-webkit', '~> 1.2.0'
  gem 'quiet_assets', '~> 1.0.3'
  gem 'factory_girl_rails', '~> 4.4.1'
end

gem_group :production do
  gem 'rails_12_factor', '~> 0.0.2'
  gem 'unicorn', '~> 4.3.1'
end

run 'bundle install'
run 'rails g rspec:install'

git :init
git add: '.'
git commit: "-am 'Initial commit'"
