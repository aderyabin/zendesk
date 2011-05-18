class Zendesk::Comment < Zendesk::Resource

  attributes :created_at, :via_id, :value, :type, :is_public, :author_id, :attachments
  protected_attributes :ticket_id

  def initialize(attributes = {})
    load_attributes(attributes) 
    @ticket_id = attributes[:ticket_id] || attributes['ticket_id']
    @is_public ||= false
    super
  end

  def self.create(attributes = {})
    instance = new(attributes)
    instance.save
  end

  def to_xml    
    { :value => value, :is_public => is_public }.to_xml(:skip_instruct => true, :root=>:comment)
  end

  def save
    begin
      response = RESOURCE["tickets/#{ticket_id}.xml"].put self.to_xml, :content_type => 'application/xml'
      return (200..300).include?(response.headers[:status].to_i)
    rescue Exception => e
      puts e.message
      return false
    end
  end

end