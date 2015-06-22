require 'spec_helper'

describe CSSpec::QUnit do

  describe "initialize" do
    it "should accept a Context" do
      context = CSSpec::Context.new(CSSpec::Document.new(''))
      expect(CSSpec::QUnit.new(context).context).to eq context
    end
    it "should raise an exception if not provided a Context object" do
      expect { CSSpec::QUnit.new('not a context') }.to raise_error ArgumentError
    end
  end

end