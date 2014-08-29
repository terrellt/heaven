source 'https://rubygems.org'

gem "rails",    "~>4.1.0"
gem "resque"
gem "resque-lock-timeout"
gem "octokit"
gem "unicorn"
gem "yajl-ruby"
gem "posix-spawn"
gem "warden-github-rails"
gem 'newrelic_rpm'

# Providers
gem "dpl",        "1.5.7"
gem "aws-sdk"
gem "capistrano", "2.9.0"
gem 'capistrano-ext'

# Notifiers
gem "hipchat"
gem "campfiyah"
gem "slack-notifier"
gem "flowdock"

group :development, :test do
  gem "pry"
  gem "sqlite3"
  gem "webmock"
  gem "simplecov", "0.7.1"
  gem "rspec-rails"
end

group :development do
  gem "foreman"
  gem "meta_request"
  gem "better_errors"
  gem "binding_of_caller"
end

group :staging, :production do
  gem 'mysql2'
end
