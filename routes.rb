
get '/css/:file.css' do
  content_type 'text/css'
  File.read "public/css/#{params[:file]}.css"
end

get '/css/:file.css.map' do
  File.read "public/css/#{params[:file]}.css.map"
end

get '/qunit/:suite.html' do
  erb :qunit, views: 'csspecs', locals: { suite: params[:suite] }
end

get '/qunit/direct.js' do
  content_type 'application/javascript'
  File.read "csspecs/direct.js"
end

get '/qunit/:suite.js' do
  content_type 'application/javascript'
  CSSpec::Document.new(file: params[:suite]).to_qunit_js
end
