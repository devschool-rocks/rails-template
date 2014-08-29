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
  gem 'rails_12factor', '~> 0.0.2'
  gem 'unicorn', '~> 4.3.1'
end

gsub_file('config/routes.rb', /^\s*#.*\n/, '')

gsub_file('Gemfile', /^\s*#.*\n/, '')
gsub_file('Gemfile', /source.+$/, "source 'https://rubygems.org'\n")
gsub_file('Gemfile', /group :test/, "\ngroup :test")

prepend_file('Gemfile', "#ruby-gemset=#{@app_name}\n")
prepend_file('Gemfile', "ruby '2.1.2'\n")

run 'curl -o config/unicorn.rb https://raw.githubusercontent.com/joemsak/rails-template/master/config/unicorn.rb'
run 'rm README*'
run 'touch README.md'
run 'cd .. && cd -'
run 'bundle install'
run 'rails g rspec:install'

git :init
git add: '.'
git commit: "-am 'Initial commit'"
