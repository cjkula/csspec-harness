require 'spec_helper'

describe CSSpec::Document do

  describe "initialize" do
    it "should recognize a string argument as a document" do
      expect(CSSpec::Document.new('a string').source).to eq 'a string'
    end
    it "should read a specified file" do
      expect(File).to receive(:read).and_return "csspec document"
      expect(CSSpec::Document.new(file: 'somefile').source).to eq 'csspec document'
    end
    it "should raise an exception if supplied with something other than a string or a hash" do
      expect { CSSpec::Document.new([]) }.to raise_error ArgumentError
      expect { CSSpec::Document.new(nil) }.to raise_error ArgumentError
    end
    it "should raise an exception if the hash argument does not have a :file attribute" do
      expect { CSSpec::Document.new({}) }.to raise_error ArgumentError
    end
    it "should raise an exception if a supplied file does not exist in the CSSPEC directory" do
      expect { CSSpec::Document.new(file: '__not-a-file__') }.to raise_error Errno::ENOENT
    end
  end

  describe "#lines" do
    it "should divide source into lines" do
      expect(CSSpec::Document.new("1\n2\n3").lines).to eq %w(1 2 3)
    end
    it "should return an empty array if document has no length" do
      expect(CSSpec::Document.new('').lines).to eq []
    end
  end

  describe "#context" do
    it "should return a Context creates with lines" do
      document = CSSpec::Document.new("the code")
      context = instance_double("CSSpec::Context")
      expect(CSSpec::Context).to receive(:new).with(document).and_return context
      expect(document.context).to eq context
    end
  end

  describe "#to_qunit_js" do
    it "should pass the context to a new QUnit object" do
      document = CSSpec::Document.new('')
      context = CSSpec::Context.new(document)
      expect(document).to receive(:context).and_return context
      document.to_qunit_js
    end
    it "should call #render_js on the new QUnit object" do
      qunit = instance_double("CSSpec::QUnit")
      expect(CSSpec::QUnit).to receive(:new).and_return qunit
      expect(qunit).to receive(:render_js)
      CSSpec::Document.new('').to_qunit_js
    end
  end

end