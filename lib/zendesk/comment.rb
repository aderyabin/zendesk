class Zendesk::Comment < Zendesk::Resource
  
  attributes :created_at, :via_id, :value, :type, :is_public, :author_id, :attachments
  protected_attributes :ticket_id
  
  def initialize(attributes = {})
    load_attributes(attributes) 
    super
  end
  
  def self.create(ticket_id, value, is_public = false)
    instance = new(:ticket_id => ticket_id, :value => value, :is_public => is_public)
    instance.save
  end
  
  def to_xml    
    { :value => value, :is_public => is_public }.to_xml(:skip_instruct => true, :root=>:ticket)
  end
  
  def save
    RESOURCE["tickets/#{id}.xml"].put self.to_xml, :content_type => 'application/xml'
  end
  
end