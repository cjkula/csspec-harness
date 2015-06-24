# libraries
require 'rspec'
require 'rspec/mocks'
require 'rack/test'

# app
require File.join(File.dirname(__FILE__), '../app.rb')


# setup test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

def app
  Sinatra::Application
end

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  conf.color = true
end
