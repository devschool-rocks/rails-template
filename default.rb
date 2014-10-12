gem 'underscore-rails', '~> 1.7'
gem 'foundation-rails', '~> 5.3'
gem 'friendly_id', '~> 5.0'
gem 'draper', '~> 1.3'

gem_group :test do
  gem 'pry-rails', '~> 0.3'
  gem 'rspec-rails', '~> 3.0'
  gem 'database_cleaner', '~> 1.3'
  gem 'launchy', '~> 2.4'
  gem 'capybara-webkit', '~> 1.2'
  gem 'quiet_assets', '~> 1.0'
  gem 'factory_girl_rails', '~> 4.4'
  gem 'poltergeist', '~> 1.5'
  gem 'konacha', '~> 3.2'
  gem 'guard-konacha', '~> 1.0'
  gem 'spring-commands-rspec', '~> 1.0'
end

gem_group :test, :development do
  gem 'sinon-rails', '~> 1.10'
end

gem_group :production do
  gem 'rails_12factor', '~> 0.0'
  gem 'unicorn', '~> 4.3'
end

run 'bundle install'

gsub_file('config/routes.rb', /^\s*#.*\n/, '') # remove comments

gsub_file('config/database.yml', /^\s*#.*\n/, '') # remove comments
gsub_file('config/database.yml', /^\n/, '') # remove empty lines
gsub_file('config/database.yml', /\s+username.*$/, '')
gsub_file('config/database.yml', /\s+password.*$/, '')

gsub_file('Gemfile', /^\s*#.*\n/, '') # remove comments
inject_into_file('Gemfile', "\n", after: "source 'https://rubygems.org'")
inject_into_file('Gemfile', "\n", before: "group :test do")
prepend_file('Gemfile', "#ruby-gemset=#{@app_name}\n")
prepend_file('Gemfile', "ruby '2.1.3'\n")

remove_file 'README.rdoc'
create_file 'README.md'

run 'curl -o config/unicorn.rb https://raw.githubusercontent.com/joemsak/rails-template/master/config/unicorn.rb'
run 'curl -o Procfile https://raw.githubusercontent.com/joemsak/rails-template/master/Procfile'

rake "db:create", :env => 'development'
rake "db:create", :env => 'test'

generate 'rspec:install'
generate 'foundation:install'

run 'guard init konacha'
run 'spring binstub rspec'

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
