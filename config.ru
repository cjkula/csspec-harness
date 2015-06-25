require "./app.rb"
require "tilt/sass"
run Sinatra::Application
spawn "scss --watch scss:public/css"