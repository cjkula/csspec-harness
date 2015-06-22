module CSSpec
  class Block
    attr_reader :context, :start_offset, :end_offset, :type

    # attr_accessor :indent
    # attr_accessor :content

    def initialize(context, offset)
      raise ArgumentError unless context.is_a?(CSSpec::Context) && 
                                 offset.is_a?(CSSpec::Offset)
      @context = context
      @start_offset = first_content_offset(offset)

      # matches = /^(?<indent>\s*)(?<content>.+)?$/.match(text)
      # @indent = matches[:indent]
      # @content = matches[:content]
    end

    def lines
      context.document.lines
    end

    def first_content_offset(offset)
      line_offset = offset.line
      column_offset = offset.column
      while (line = lines[line_offset])
        if (i = line.index(/\S+/, column_offset))
          return Offset.new(line_offset, column_offset > 0 ? i : 0)
        end
        line_offset += 1
        column_offset = 0
      end
      nil
    end

    def parse
      @type = case directive
              when 'html'
                directive.downcase.to_sym
              end
    end

    # look for a CSSpec directive at beginning of block
    def directive
      match = /^@(?<directive>.+)\b$/.match(first_content)
      match ? match[:directive] : nil
    end

    # finding first non-whitespace content starting at indicated offset
    # ...pretty verbose...
    def first_content
      index = start_offset.line
      line = lines[index][start_offset.column..-1]
      while line
        content = /^\s*(?<content>.+)?$/.match(line)[:content]
        return content if content
        index += 1
        line = lines[index]
      end
      nil
    end
    
  end
end