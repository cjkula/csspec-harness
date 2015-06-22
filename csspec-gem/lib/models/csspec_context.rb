module CSSpec
  class Context
    attr_accessor :document, :parent_block, :blocks

    def initialize(document, parent_block = nil, offset = Offset.new(0, 0))
      raise ArgumentError unless document.is_a?(Document)
      raise ArgumentError unless parent_block.is_a?(Block) || parent_block.nil?
      @document = document
      @parent_block = parent_block
      @blocks = []
      add_blocks(offset) if document.lines.size > 0
    end

    def add_blocks(next_offset)
      while next_offset
        blocks << (block = Block.new(self, next_offset))
        next_offset = block.end_offset
      end
    end

  end
end