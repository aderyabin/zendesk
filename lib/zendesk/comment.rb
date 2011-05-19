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
    { :value => value, :is_public => is_public }.to_xml(:skip_instruct => true, :root=>:comment)
  end

  def save
    begin
      response = resource["tickets/#{ticket_id}.xml"].put self.to_xml, :content_type => 'application/xml'
      return (200..300).include?(response.headers[:status].to_i)
    rescue Exception => e
      puts e.message
      return false
    end
  end

end