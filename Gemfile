source 'http://rubygems.org'

gemspec

group :development do
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-ctags-bundler'
end

group :test do
  gem 'rspec'
  gem 'rack-test'
  gem 'byebug'
end

group :guard_linux do
  gem 'libnotify', require: nil
  gem 'rb-inotify', require: nil
end

group :guard_mac do
  gem 'rb-fsevent', '~> 0.9', require: nil
end
