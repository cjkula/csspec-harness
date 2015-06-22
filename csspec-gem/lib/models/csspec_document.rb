module CSSpec
  class Document
    attr_reader :source

    def initialize(source_or_opts)
      @source = case source_or_opts
                when String
                  source_or_opts
                when Hash
                  raise ArgumentError unless (filename = source_or_opts[:file])
                  File.read File.join(CSSpec::CSSPEC_DIR, "#{filename}.csspec")
                else
                  raise ArgumentError
                end
    end

    def lines
      @lines ||= source.split("\n")
    end

    def context
      @context ||= Context.new(self)
    end

    def to_qunit_js
      QUnit.new(context).render_js
    end

  end
end
