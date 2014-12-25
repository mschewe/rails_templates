# Application settings
environment '
    config.generators do |g|
      g.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: true,
        request_specs: false
      g.fixture_replacement :factory_girl, dir: "spec/factories"
  end
'

# Setup configuration
create_file "config/application.yml" do <<-FILE
defaults: &defaults

development:
  <<: *defaults

test:
  <<: *defaults
FILE
end

inject_into_file "config/application.rb", before: "module" do <<-FILE
if File.exists?(File.expand_path('../application.yml', __FILE__))
  config = YAML.load(File.read(File.expand_path('../application.yml', __FILE__)))
  config.merge! config.fetch(Rails.env, {})
  config.each do |key, value|
    ENV[key] ||= value.to_s unless value.kind_of? Hash
  end
end

FILE
end


# Gemfile
inject_into_file "Gemfile", after: "source 'https://rubygems.org'" do <<-FILE

ruby "2.1.5"
FILE
end

gem_group :development, :test do
  gem "pry"
  gem "rspec-rails"
  gem "factory_girl_rails"
end

gem_group :test do
  gem "selenium-webdriver"
  gem "capybara"
  gem "faker"
  gem "database_cleaner"
  gem "launchy"
end

gem_group :development do
  gem "quiet_assets"
end

uncomment_lines 'Gemfile', /bcrypt/
uncomment_lines 'Gemfile', /unicorn/
uncomment_lines 'Gemfile', /capistrano-rails/

append_to_file 'Gemfile', "\n# Boostrap"
gem "font-awesome-rails"
gem "bootstrap-sass"

append_to_file 'Gemfile',  "\n\n# UI Helper"
gem "so_meta"
gem "local_time"
gem "autoprefixer-rails"

run "bundle install"
run "bundle exec spring binstub --all"
run "spring stop"
run "rails generate rspec:install"

append_to_file ".rspec" do <<-FILE
--format documentation
FILE
end

create_file "app/assets/javascripts/init.js.coffee" do <<-FILE
window.App ||= {}
FILE
end
append_file "app/assets/javascripts/application.js", "//= require init"

inject_into_file "app/assets/javascripts/application.js", before: "//= require_tree ." do <<-FILE
//= require bootstrap
FILE
end

create_file "app/assets/stylesheets/application.css.scss" do <<-FILE
/*
 *= require_self
 */

@import "bootstrap";
@import "font-awesome";
FILE
end

remove_file "app/assets/stylesheets/application.css"

git :init
append_file ".gitignore", "config/application.yml"

git add: "."
git commit: "-a -m 'Initial commit'"
