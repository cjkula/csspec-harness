require 'spec_helper'

describe "CSSpecs" do

  describe "#to_qunit" do

    it "should read the correct test suite file from /csspecs" do
      expect(File).to receive(:read).with "csspecs/fakename.csspec"
      allow(CSSpecs).to receive(:parse)
      allow(CSSpecs::QUnit).to receive(:render)
      CSSpecs.to_qunit :fakename
    end

    it "should call the csspec parser" do
      allow(File).to receive(:read).and_return "fake csspecs"
      expect(CSSpecs).to receive(:parse).with "fake csspecs"
      allow(CSSpecs::QUnit).to receive(:render)
      CSSpecs.to_qunit :fakename
    end

    it "should call the qunit renderer" do
      allow(File).to receive(:read)
      allow(CSSpecs).to receive(:parse).and_return []
      expect(CSSpecs::QUnit).to receive(:render).with []
      CSSpecs.to_qunit :fakename
    end

  end

end