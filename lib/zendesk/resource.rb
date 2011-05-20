class Zendesk::Resource
  include Zendesk::Properties
  include Zendesk::Constants
  
  # TODO: Make load file as optional

  def initialize(attrs = {})
    load_attributes(attrs)
    load_properties(attrs)
  end
  
  def load_data(xml_stream)
    Zendesk.xml_in(xml_stream)
  end
  
  def self.create(attrs = {})
    instance = new(attrs)
    instance.save
    instance
  end
end