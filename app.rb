require 'rubygems'
require 'bundler'
require 'sinatra'

# add directories to load path
$:.unshift File.dirname(__FILE__)
$:.unshift File.join(File.dirname(__FILE__), 'lib')

# add target gem (rather than bundling for now)
$:.unshift File.join(File.dirname(__FILE__), 'csspec-gem/lib')

# Load models
# Dir["models/*.rb"].each { |filename| require filename }

# load application routes
require 'routes'
