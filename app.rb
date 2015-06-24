require 'rubygems'
require 'bundler'
require 'sinatra'

# add directories to load path
$:.unshift File.dirname(__FILE__)

# for development purposes: add target gem path 
# and require base file rather than bundling
$:.unshift File.join(File.dirname(__FILE__), 'csspec-gem/lib')
require 'csspec'

# load application routes
require 'routes'
