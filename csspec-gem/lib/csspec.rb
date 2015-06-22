# Load models
root = File.dirname(__FILE__)
Dir[File.join(root, 'models/*.rb')].each { |filename| require filename }

module CSSpec
  class MissingDocumentError < StandardError; end

  CSSPEC_DIR = 'csspecs'
end
