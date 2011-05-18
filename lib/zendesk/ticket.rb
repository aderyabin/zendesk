class Zendesk::Ticket < Zendesk::Resource
 include Zendesk::Constants
  
  datetimes :created_at, :updated_at
  attributes :subject, :description, :status, :assignee_id, :requester_name, :requester_email
  protected_attributes :nice_id, :priority_id, :status_id, :via_id, :ticket_type_id, :current_tags, :comments
  properties :status, :ticket_type, :priority, :via


  alias_attribute :id, :nice_id
  alias_attribute :set_tags, :current_tags
    
  def initialize(attrs = {})
    @comments = []

    load_fields
    load_attributes(attrs)
    load_properties(attrs)
    super
  end
  
  def load_field_entries(data)
    data['ticket_field_entries'].each do |field_entry|
      method_name = @field_ids.index(field_entry['ticket_field_id'])
      send("#{method_name}=", field_entry['value'])
    end
  end
  
  def load_comments(data)
    @comments = []
    data['comments'].each do |comment|
      @comments << Zendesk::Comment.new(comment)
    end
  end
  
  def self.create(attributes = {})
    instance = new(attributes)
    instance.save
  end
  
  def create_comment(value, is_public = true)
    if Zendesk::Comment.create(:ticket_id => self.id, :value => value, :is_public => is_public)
      reload
    else
      false
    end
  end
  
  
  def self.find(id)
    begin
      self.new().load(id)
    rescue Exception => e
      puts e.message
      nil
    end
  end

  def load(id)
    begin
      data = load_data(RESOURCE["#{self.class.to_s.demodulize.downcase.pluralize}/#{id}.json"].get)
      load_attributes(data)
      load_protected_attributes(data)
      load_field_entries(data)
      load_comments(data)
      self
    rescue Exception => e
      puts e.message
      nil
    end
  end
  
  def save
    begin
      response = if self.id
          RESOURCE["tickets/#{id}.xml"].put self.to_xml, :content_type => 'application/xml'
        else  
          RESOURCE["tickets.xml"].post self.to_xml, :content_type => 'application/xml'
        end
      if (200..300).include?(response.headers[:status].to_i)
        load(id || response.headers[:location].scan(/\d+/).first.to_i)
        return true
      else
        return false
      end
    rescue Exception => e
      puts e.message
      return false
    end
  end
  
  def reload
    return false unless id
    begin
      load(id)
    rescue Exception => e
      puts e.message
      nil
    end
  end
  
  def to_xml
    result = {}
    (attributes -  @field_ids.keys).each do |obj|
      if instance_variable_get(:"@#{obj.to_s}").present?
        result[obj.to_s.downcase] = instance_variable_get(:"@#{obj.to_s}") 
      end
    end
    
    result[:ticket_field_entries] = []
    @field_ids.each_pair do |key, value|
      if instance_variable_get(:"@#{key.to_s}").present?
        result[:ticket_field_entries] << {:ticket_field_id => value, :value => instance_variable_get(:"@#{key.to_s}").to_s}
      end
    end
    
    result[:set_tags] = current_tags
    result.to_xml(:skip_instruct => true, :root=>:ticket)
  end
  
  def tags
    @current_tags.split()
  end
  
  def tags=(tags)
    @current_tags = tags.to_a.join(' ')
  end
  
  def load_fields
    attr_keys = CONFIG['ticket'] || {}
    @field_ids = {}
    field_names = attr_keys.keys
    unless field_names.blank?
      field_names = field_names.map(&:to_sym)
      attr_keys.keys.each do |attr_name|
        @field_ids[attr_name.to_sym]  = attr_keys[attr_name]
      end
      field_names.each{ |field_name| self.class.attributes field_name.to_sym }
    end
  end
  
end