require 'spec_helper'

describe CSSpec::Offset do
  it "should accept a line and column" do
    offset = CSSpec::Offset.new(10, 20)
    expect(offset.line).to eq 10
    expect(offset.column).to eq 20
  end
  it "should permit nil line/column values" do
    offset = CSSpec::Offset.new(nil, nil)
    expect(offset.line).to be_nil
    expect(offset.column).to be_nil   
  end
end