module CSSpec
  class QUnit
    attr_reader :context

    def initialize(context)
      raise ArgumentError unless context.is_a?(CSSpec::Context)
      @context = context
    end

    def render_js
      ''
    end

  end
end