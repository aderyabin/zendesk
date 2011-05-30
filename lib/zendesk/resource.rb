class Zendesk::Resource
  include Zendesk::Properties
  include Zendesk::Constants
  
  attr_accessor :on_behalf_of
  
  # TODO: Make load file as optional

  def initialize(attrs = {})
    @on_behalf_of = attrs.delete(:on_behalf_of)
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
  
  
  # test access to zendesk
  # return true if authenticated successfully else false
  def self.check_access
    begin
      Zendesk.resource["users.xml"].get
      return true
    rescue
      false
    end
  end
end