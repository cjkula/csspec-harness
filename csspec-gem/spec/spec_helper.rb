require 'rubygems'
require 'rspec'
require File.join(File.dirname(__FILE__), '../lib/csspec')

### Object Makers ###

def new_document_context(source = '', opts = nil)
  args = [CSSpec::Document.new(source)]
  if opts
    args << opts[:parent]
    args << opts[:offset] if opts[:offset]
  end
  CSSpec::Context.new(*args)
end

def new_block(source = '', opts = nil)
  offset = opts && opts[:offset] ? opts[:offset] : CSSpec::Offset.new(0, 0)
  context = opts && opts[:context] ? opts[:context] : new_document_context(source, opts)
  CSSpec::Block.new(context, offset)
end
