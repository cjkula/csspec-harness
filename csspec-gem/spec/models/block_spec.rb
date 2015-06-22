require 'spec_helper'

describe CSSpec::Block do
  describe "initialize" do
    it "should accept a Context" do
      block = new_block '', context: (context = new_document_context)
      expect(block.context).to eq context
    end
    # NOW SET BY #first_content_offset
    # it "should accept a start offset" do
    #   start_offset = CSSpec::Offset.new(0, 0)
    #   block = new_block('content', offset: start_offset)
    #   expect(block.start_offset).to eq start_offset
    # end
    it "should raise an error if not provided a CSSpec::Context" do
      expect {
        CSSpec::Block.new('not a Context', CSSpec::Offset.new(0, 0))
      }.to raise_error ArgumentError
    end
    it "should raise an error if not provided a CSSpec::Offset" do
      expect {
        CSSpec::Block.new(new_document_context, 'not an Offset')
      }.to raise_error ArgumentError
    end
    it "should call #first_content_offset and assign result to start_offset" do
      offset = double("offset")
      expect_any_instance_of(CSSpec::Block).to receive(:first_content_offset).and_return(offset)
      block = CSSpec::Block.new(new_document_context, CSSpec::Offset.new(0, 0))
      expect(block.start_offset).to eq offset
    end
    # DECOUPLING (FOR THE MOMENT?)
    # it "should call #parse" do
    #   expect_any_instance_of(CSSpec::Block).to receive(:parse)
    #   CSSpec::Block.new(new_document_context, CSSpec::Offset.new(0, 0))
    # end
  end

  describe "#lines" do
    it "should reference the lines of the containing document" do
      document = CSSpec::Document.new("line1\nline2")
      block = new_block nil, context: CSSpec::Context.new(document)
      expect(block.lines).to eq %w(line1 line2)
    end
  end

  describe "#parse" do
    it "should recognize an html fixture block" do
      block = new_block "@html\n\t<div>Ahoy there</div>"
      block.parse
      expect(block.type).to eq :html
    end
  end

  # testing this as coupled in #initialize
  describe "#first_content_offset" do
    def offset_coords(source, line = 0, column = 0)
      offset = new_block(source, offset: CSSpec::Offset.new(line, column)).start_offset
      offset ? [offset.line, offset.column] : nil
    end
    context "when starting at the beginning of the document" do
      it "should advance the start_offset to the beginning of the first line with content" do
        expect(offset_coords("content")).to eq [0, 0]
        expect(offset_coords(" content")).to eq [0, 0]
        expect(offset_coords("\ncontent")).to eq [1, 0]
        expect(offset_coords("   \ncontent")).to eq [1, 0]
        expect(offset_coords("\t\n    \ncontent")).to eq [2, 0]
      end
      it "should set start_offset to nil if no content" do
        expect(offset_coords('')).to be_nil
      end
    end
    context "when starting in the middle of the document" do
      it "should advance the start_offset to the beginning of the first line with content at or after the initial start_offset" do
        expect(offset_coords("line1\nline2", 1)).to eq [1, 0]
        expect(offset_coords("line1\n    line2", 1)).to eq [1, 0]
        expect(offset_coords("line1\n\nline3", 1)).to eq [2, 0]
        expect(offset_coords(" line1\n\t\t\n line3", 1)).to eq [2, 0]
      end
      it "should set start_offset to nil if no content after start line" do
        expect(offset_coords('line1\n', 1)).to be_nil
      end
    end
    context "when starting in the middle of a line" do
      it "should advance the start_offset to the next content on the same line" do
        expect(offset_coords("line1 content", 0, 5)).to eq [0, 6]
        expect(offset_coords("line1\t\tcontent", 0, 5)).to eq [0, 7]
      end
      it "should set start_offset to nil if no content after mid-line offset" do
        expect(offset_coords('line1', 0, 5)).to be_nil
      end
      it "should advance the start_offset to the start of the next content line if no further content on the same line" do
        expect(offset_coords("line1\nline2", 0, 5)).to eq [1, 0]
        expect(offset_coords("line1   \nline2", 0, 5)).to eq [1, 0]
        expect(offset_coords("line1\n\tline2", 0, 5)).to eq [1, 0]
        expect(offset_coords("line1   \n\n  line3", 0, 5)).to eq [2, 0]
      end
      it "should set start_offset to nil if no non-whitespace content after mid-line offset" do
        expect(offset_coords("line1\n ", 0, 5)).to be_nil
      end
    end
  end

  # it "should accept a line number" do
  #   expect(CSSpec::Block.new(['line'], 99).first_line_number).to eq(99)
  # end
  # it "should raise an error if line count is zero" do
  #   expect { CSSpec::Block.new [] }.to raise_error CSSpec::MissingDocumentError
  # end
  # it "should parse an empty line as a blank indent with nil content" do
  #   block = CSSpec::Block.new ['']
  #   expect(block.indent).to eq ''
  #   expect(block.content).to be_nil
  # end
  # it "should parse a whitespace line as whitespace indent with nil content" do
  #   block = CSSpec::Block.new [" \t "]
  #   expect(block.indent).to eq " \t "
  #   expect(block.content).to be_nil
  # end
  # it "should parse a line without whitespace as a blank indent with content" do
  #   block = CSSpec::Block.new "content"
  #   expect(block.indent).to eq ""
  #   expect(block.content).to eq "content"
  # end
  # it "should parse an indented line with content" do
  #   block = CSSpec::Block.new "\t content"
  #   expect(block.indent).to eq "\t "
  #   expect(block.content).to eq "content"
  # end

end
