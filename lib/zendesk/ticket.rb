class Zendesk::Ticket < Zendesk::Resource
  include Zendesk::TicketConstants
  
  
  properties :status, :ticket_type, :priority, :via
  attributes :subject, :description, :status, :assignee_id, :requester_name, :requester_email
  protected_attributes :nice_id, :created_at, :updated_at, :priority_id, :status_id, :via_id, :ticket_type_id, :current_tags, :created_at, :updated_at

  alias_attribute :id, :nice_id
  alias_attribute :set_tags, :current_tags
    
  def initialize(attributes = {})
    
    @attributes = @@attributes
    @protected_attributes = @@protected_attributes
    @properties = @@properties
    
    @properties.each do |mn|
      
      self.class.attributes "#{mn}_id".to_sym
      
      method_name = mn.to_s
      class_eval <<-END
        def #{method_name}
          #{method_name.upcase}[@#{method_name}_id.to_i]
        end
      END

      class_eval <<-END
        def #{method_name}=(value)
          @#{method_name}_id = #{method_name.upcase}.index(value)
        end
      END
      
      if val = (attributes[method_name.to_s] || attributes[method_name.to_sym])
        self.send(:"#{method_name}=", val)
      end
    end
    
    %w(created_at updated_at).each do |method_name|
      class_eval <<-END
        def #{method_name}
          DateTime.parse @#{method_name}
        end
      END
    end

    @comments = []
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

    
    load_attributes(attributes) 
    super
  end
  
  def load_fields(data)
    data['ticket_field_entries'].each do |field_entry|
      method_name = @field_ids.index(field_entry['ticket_field_id'])
      send("#{method_name}=", field_entry['value'])
    end
  end
  
  def self.create(attributes = {})
    instance = new(attributes)
    instance.save
  end
  
  def save
    begin
      response = if self.id
          RESOURCE["tickets/#{id}.xml"].put self.to_xml, :content_type => 'application/xml'
        else  
          RESOURCE["tickets.xml"].post self.to_xml, :content_type => 'application/xml'
        end
      if (200..300).include?(response.headers[:status].to_i)
        load(id || extract_id(response))
        return true
      else
        return false
      end
    rescue Exception => e
      puts e.message
      return false
    end
  end
  
  def extract_id(response)
    response.headers[:location].scan(/\d+/).first.to_i
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
  
end