gem 'underscore-rails', '~> 1.8'
gem 'foundation-rails', '~> 5.5'
gem 'friendly_id', '~> 5.1'

gem_group :test do
  gem 'rspec-rails', '~> 3.3'
  gem 'database_cleaner', '~> 1.4'
  gem 'launchy', '~> 2.4'
  # gem 'capybara-webkit', '~> 1.6'
  gem 'factory_girl_rails', '~> 4.5'
  gem 'spring-commands-rspec', '~> 1.0'
end

gem_group :test, :development do
  gem 'quiet_assets', '~> 1.1'
  gem 'dotenv-rails', '~> 2.0'
  gem 'pry-rails', '~> 0.3'
  gem 'pry-nav', '~> 0.2'
end

gem_group :production do
  gem 'rails_12factor', '~> 0.0'
  gem 'unicorn', '~> 4.9'
end

run 'bundle install'

gsub_file('config/routes.rb', /^\s*#.*\n/, '') # remove comments

gsub_file('config/database.yml', /^\s*#.*\n/, '') # remove comments
gsub_file('config/database.yml', /^\n/, '') # remove empty lines
gsub_file('config/database.yml', /\s+username.*$/, '')
gsub_file('config/database.yml', /\s+password.*$/, '')

gsub_file('Gemfile', /^\s*#.*\n/, '') # remove comments
inject_into_file('Gemfile', "\n\n", after: "source 'https://rubygems.org'")
prepend_file('Gemfile', "#ruby-gemset=#{@app_name}\n")
prepend_file('Gemfile', "ruby '2.2.3'\n")

remove_file 'README.rdoc'
create_file 'README.md'

run 'curl -o config/unicorn.rb https://raw.githubusercontent.com/joemsak/rails-template/master/config/unicorn.rb'
run 'curl -o Procfile https://raw.githubusercontent.com/joemsak/rails-template/master/Procfile'

rake "db:create", :env => 'development'
rake "db:create", :env => 'test'

generate 'rspec:install'
generate 'foundation:install'

run 'spring binstub rspec'

gsub_file('app/views/layouts/application.html.erb', 'foundation-rails', @app_name)
gsub_file('spec/spec_helper.rb', /^\s*(?:#|=).*\n/, '') # remove comments

append_file 'Rakefile', <<RAKEFILE
begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end
task default: :spec
RAKEFILE

git :init
git add: '.'
git commit: "-am 'Initial commit'"
