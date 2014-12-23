# Application settings
environment '
    config.generators do |g|
      g.helper = false
      g.view_specs = false
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

inject_into_file "Gemfile", after: "source 'https://rubygems.org'" do <<-FILE


ruby "2.1.5"
FILE
end

gem_group :development, :test do
  gem "pry"
end

gem_group :test do
  gem "selenium-webdriver"
  gem "capybara"
end

gem_group :development do
  gem "quiet_assets"
end

gem "font-awesome-rails"
gem "unicorn"
gem "bootstrap-sass"
gem "so_meta"
gem "local_time"

run "bundle install"
run "bundle exec spring binstub --all"


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
