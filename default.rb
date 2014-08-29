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
prepend_file('Gemfile', "ruby '2.1.2'\n")

remove_file 'README.rdoc'
create_file 'README.md'

run 'curl -o config/unicorn.rb https://raw.githubusercontent.com/joemsak/rails-template/master/config/unicorn.rb'

rake "db:create", :env => 'development'
rake "db:create", :env => 'test'

generate 'rspec:install'

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
