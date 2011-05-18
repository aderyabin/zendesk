class Zendesk::Resource
  include Zendesk::Properties
  include Zendesk::Constants
  
  # TODO: Make load file as optional

  def initialize(attrs = {})
    load_attributes(attrs)
    load_properties(attrs)
  end
  
  def load_data(xml_stream)
    Hash.from_xml(xml_stream)
  end
end