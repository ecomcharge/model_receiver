ENV['RACK_ENV'] = 'test'
ENV['ENV'] = 'test'

$:.unshift File.expand_path("../lib", File.dirname(__FILE__))

require 'rubygems'
require 'bundler'
Bundler.setup :default, :test

require 'rspec'
require 'rack/test'

require 'model_receiver'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
