
get '/:file.css' do
  content_type 'text/css'
  scss params[:file].to_sym, views: 'scss'
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
