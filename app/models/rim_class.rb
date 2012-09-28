class RimClass < ActiveRecord::Base
  class RimAttr
    attr :xml
    attr_accessor :description

    def initialize(xml)
      @xml = xml
    end

    def name
      xml[:name]
    end

    def description
      xml.xpath('./annotations/documentation/definition').first.content.strip
    end

    def usage_notes
      xml.xpath('./annotations//usageNotes/text').try(:to_xml).try(:html_safe)
    end

    def other_annotation
      xml.xpath('./annotations//otherAnnotation/text').try(:to_xml).try(:html_safe)
    end

    def attrs
      xml.attributes
    end

    def is_mandatory?
      xml[:isMandatory] == 'true'
    end

    def conformance
      xml[:conformance]
    end

    def max
      xml[:maximumMultiplicity]
    end
    def min
      xml[:minimumMultiplicity] 
    end
  end

  set_primary_key :name
  attr_accessible :name, :parent_name, :xml

  def doc
    @doc ||= Nokogiri::XML(self.xml)
  end

  def formatted_xml
    doc.to_xml( indent:1, indent_text:" ")
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

  def other_annotation
    doc.xpath('//annotations/documentation/otherAnnotation').first.try(:to_xml).try(:html_safe)
  end

  def code
    doc.xpath('//definingVocabulary/code').first
  end

  def code_system_name
    code.try(:[],:codeSystemName)
  end

  def rim_attributes
    @rim_attributes ||= doc.xpath('//attribute').map do |attr|
      RimAttr.new(attr)
    end
  end
end
