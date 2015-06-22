require 'spec_helper'

describe CSSpec::Context do

  describe "initialize" do
    it "should raise an exception if not provided a Document" do
      expect { CSSpec::Context.new 'not a CSSpec::Document' }.to raise_error ArgumentError
    end
    it "should accept a parent block" do
      document = CSSpec::Document.new('')
      parent_block = CSSpec::Block.new(CSSpec::Context.new(document), CSSpec::Offset.new(0, 0))
      context = CSSpec::Context.new(document, parent_block)
      expect(context.parent_block).to eq parent_block
    end
    it "should accept a nil parent_block" do
      expect(CSSpec::Context.new(CSSpec::Document.new('')).parent_block).to be_nil
    end
    it "should raise an exception if parent_block is not a block or nil" do
      expect { 
        new_document_context '', parent: "not a CSSpec::Block"
      }.to raise_error ArgumentError
    end
    it "should call :add_blocks if document has content" do
      expect_any_instance_of(CSSpec::Context).to receive :add_blocks
      new_document_context 'content'
    end
    it "should not add any blocks when document is empty" do
      expect_any_instance_of(CSSpec::Context).to_not receive :add_blocks
      context = new_document_context
      expect(context.blocks).to eq []
    end
    it "should invoke add_blocks at a provided offset" do
      offset = CSSpec::Offset.new(1, 5)
      expect_any_instance_of(CSSpec::Context).to receive(:add_blocks).with offset
      new_document_context 'content', offset: offset
    end
    it "should invoke #add_blocks at Offset = (0, 0) if no offset provided" do
      allow_any_instance_of(CSSpec::Context).to receive(:add_blocks) do |context, offset|
        expect(offset.line).to eq(0)
        expect(offset.column).to eq(0)
      end
      new_document_context 'content'
    end
  end

  describe "#add_blocks" do
    before(:each) do
      @context = new_document_context
    end
    it "should pass the calling context to a new Block" do
      block = instance_double("Block", end_offset: nil)
      offset = CSSpec::Offset.new(0, 0)
      expect(CSSpec::Block).to receive(:new).with(@context, offset).and_return(block)
      @context.add_blocks(offset)
    end
    it "should add a single block if that block has an end_offset of nil" do
      block = instance_double("Block", end_offset: nil)
      expect(CSSpec::Block).to receive(:new).once.and_return block
      @context.add_blocks(CSSpec::Offset.new(0, 0))
      expect(@context.blocks).to eq [block]
    end
    it "should add two blocks if the first has a specified end_offset" do
      first_block = instance_double("Block", end_offset: CSSpec::Offset.new(1, 0))
      second_block = instance_double("Block", end_offset: nil)
      expect(CSSpec::Block).to receive(:new).once.and_return(first_block, second_block)
      @context.add_blocks(CSSpec::Offset.new(0, 0))
      expect(@context.blocks).to eq [first_block, second_block]
    end
  end

end
