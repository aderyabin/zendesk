class Zendesk::Comment < Zendesk::Resource
  include Zendesk::Constants
  
  properties :via
  datetimes :created_at
  attributes :value, :type, :is_public, :author_id, :attachments
  protected_attributes :ticket_id

  def initialize(attrs = {})
    @ticket_id ||= attrs[:ticket_id] || attrs['ticket_id']
    @is_public ||= false
    super
  end

  def to_xml    
    Zendesk.xml_out({:comment => { :value => value, :is_public => is_public }})
  end

  def save
    begin
      response = Zendesk.resource["tickets/#{ticket_id}.xml"].put self.to_xml, :content_type => 'application/xml'
      return (200..300).include?(response.headers[:status].to_i)
    rescue Exception => e
      puts e.message
      return false
    end
  end

end