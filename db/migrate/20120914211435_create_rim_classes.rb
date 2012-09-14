require 'nokogiri'
class CreateRimClasses < ActiveRecord::Migration
  def up
    create_table :rim_classes do |t|
      t.string :name
      t.string :parent_name
      t.text :xml

      t.timestamps
    end

    doc = Nokogiri::XML(open(Rails.root.join('rim','DEFN=UV=RIM=0237.coremif')))
    doc.remove_namespaces!
    doc.xpath('//class').each do |cls|
      c = RimClass.new
      c.name = cls[:name]
      c.parent_name = cls.xpath('./parentClass').first.try(:[],:name)
      c.xml = cls.to_xml
      c.save
    end
  end

  def down
    drop_table :rim_classes
  end
end
