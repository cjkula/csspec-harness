require 'spec_helper'

describe "routes" do

  describe "/css/:file.css" do
    it "should return the stylesheet from public/css" do
      expect(File).to receive(:read).with('public/css/somefile.css').and_return ''
      get "/css/somefile.css"
    end
  end

  describe "/css/:file.css.map" do
    it "should return the sourcemap from public/css" do
      expect(File).to receive(:read).with('public/css/somefile.css.map').and_return ''
      get "/css/somefile.css.map"
    end
  end

  
  describe "/qunit/:suite.html" do
    it "should call the qunit .erb template and pass the suite name" do
      get "/qunit/suite_name.html"
      expect(last_response.body).to match /\bqunit-fixture\b/
      expect(last_response.body).to match /\bsuite_name.js\b/
    end
  end

  describe "/qunit/:suite.js" do
    it "should create a CSSpec::Document with the suite token and render to qunit js" do
      document = instance_double("Document")
      expect(CSSpec::Document).to receive(:new).with(file: 'suite_name').and_return document
      expect(document).to receive(:to_qunit_js).and_return ''
      get "/qunit/suite_name.js"
    end
  end

  # describe "/qunit/direct.js" do
  # end

end
