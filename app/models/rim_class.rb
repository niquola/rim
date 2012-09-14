class RimClass < ActiveRecord::Base
  class RimAttr
    attr :name
    attr_accessor :description

    def initialize(name)
      @name = name
    end
  end

  set_primary_key :name
  attr_accessible :name, :parent_name, :xml

  def doc
    @doc ||= Nokogiri::XML(self.xml)
  end

  def definition
    doc.xpath('//annotations/documentation/definition').first.try(:content).try(:strip)
  end

  def usage_notes
    doc.xpath('//annotations/documentation/usageNotes').first.try(:to_xml).try(:html_safe)
  end

  def design_comments
    doc.xpath('//annotations/documentation/designComments').first.try(:to_xml).try(:html_safe)
  end

  def code
    doc.xpath('//definingVocabulary/code').first
  end

  def code_system_name
    code.try(:[],:codeSystemName)
  end

  def rim_attributes
    @rim_attributes ||= doc.xpath('//attribute').map do |attr|
      rattr = RimAttr.new(attr[:name])
      rattr.description = attr.xpath('./annotations/documentation/definition').first.content.strip
      rattr
    end
  end
end
