require 'csspecs-qunit'

module CSSpecs

  module QUnit
    extend QUnitCSSpecs
  end

  def self.to_qunit(suite)
    parsed = self.parse File.read("csspecs/#{suite}.csspec")
    self::QUnit.render parsed
  end

  def self.parse(csspec)

  end

end
