gem 'devise'

gem 'friendly_id'
gem "paranoia"

gem_group :test do
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'factory_girl_rails'
  gem 'spring-commands-rspec'
  gem 'timecop'
end

gem_group :test, :development do
  gem 'quiet_assets'
  gem 'dotenv-rails'
end

gem_group :production do
  gem 'rails_12factor'
  gem 'unicorn'
  gem 'newrelic_rpm'
  gem 'therubyracer', require: "v8"
end

gem 'bootstrap', '~> 4.0.0.alpha3'
add_source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.1.0'
end

run 'bundle install --path .bundle/gems --binstubs .bundle/bin --without production'

gsub_file('config/routes.rb', /^\s*#.*\n/, '') # remove comments

gsub_file('config/database.yml', /^\s*#.*\n/, '') # remove comments
gsub_file('config/database.yml', /^\n/, '') # remove empty lines
gsub_file('config/database.yml', /\s+username.*$/, '')
gsub_file('config/database.yml', /\s+password.*$/, '')

gsub_file('Gemfile', /^\s*#.*\n/, '') # remove comments
inject_into_file('Gemfile', "\n\n", after: "source 'https://rubygems.org'")
prepend_file('Gemfile', "ruby '2.3.0'\n")

remove_file 'README.rdoc'
create_file 'README.md'

run 'curl -o config/unicorn.rb https://raw.githubusercontent.com/devschool-rocks/rails-template/master/config/unicorn.rb'
run 'curl -o config/newrelic.yml https://raw.githubusercontent.com/devschool-rocks/rails-template/master/newrelic.yml'
run 'curl -o Procfile https://raw.githubusercontent.com/devschool-rocks/rails-template/master/Procfile'
run 'curl -o .buildpacks https://raw.githubusercontent.com/devschool-rocks/rails-template/master/.buildpacks'

rake "db:create", :env => 'development'
rake "db:create", :env => 'test'

run 'rails g rspec:install'
run 'spring binstub rspec'
run 'spring binstub rake'

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

append_file '.gitignore', "spec/*.txt"

git add: '.'
git commit: "-am 'Initial commit'"

run 'heroku create'
run 'heroku buildpacks:set https://github.com/ddollar/heroku-buildpack-multi.git'
run 'heroku buildpacks:add https://github.com/gunpowderlabs/buildpack-ruby-rake-deploy-tasks'
run 'heroku config:set DEPLOY_TASKS="db:migrate"'
run 'heroku addons:create newrelic'
