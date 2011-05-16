class Zendesk::Ticket < Zendesk::Resource
  include Zendesk::TicketConstants
  
  attributes :fields, :subject, :description, :status, :assignee_id, :requester_name, :requester_email
  protected_attributes :nice_id, :created_at, :updated_at, :priority_id, :status_id, :via_id, :ticket_type_id, :current_tags, :created_at, :updated_at

  attr_accessor :fields

  alias_attribute :id, :nice_id
  alias_attribute :set_tags, :current_tags
    
  def initialize(attributes = {})
    super
    
    %w(via priority ticket_type status).each do |method_name|
      class_eval <<-END
        def #{method_name}
          #{method_name.upcase}[@#{method_name}.to_i]
        end
      END
    end
    
    %w(created_at updated_at).each do |method_name|
      class_eval <<-END
        def #{method_name}
          DateTime.parse @#{method_name}
        end
      END
    end
  end

  def load_attributes(attributes = {})
    super
    @comments = []
    attr_keys = CONFIG[self.class.to_s.demodulize.downcase] || {}
    @field_ids = {}
    field_names = attr_keys.keys
    unless field_names.blank?
      field_names = field_names.map(&:to_sym)
      attr_keys.send(:keys).each do |attr_name|
        @field_ids[attr_name.to_sym]  = attr_keys[attr_name]
      end
      @fields = Struct.new(*field_names).new
    end
  end
  
  def self.create(attributes = {})
    instance = new(attributes)
    instance.save
  end
  
  def save
    begin
      response = if self.id
      RESOURCE["tickets/#{id}.json"].put self.to_json
      else
        RESOURCE["tickets.json"].post self.to_json
      end
      if response.headers[:status] == '201 Created'
        load(extract_id(response))
        return true
      else
        return false
      end
    rescue
      false
    end
  end
  
  def extract_id(response)
    response.headers[:location].scan(/\d+/).first.to_i
  end
  
  def to_json
    result = { :ticket => {} }
    [:subject, :description, :set_tags, :requester_name, :requester_email].each do |obj|
      result[:ticket][obj.to_s.downcase] = try(obj)
    end
    result[:ticket]['ticket_field_entries'] = []
    fields.each_pair do |key, value|
      result[:ticket]['ticket_field_entries'] << {:ticket_field_entry => {:ticket_field_id => @field_ids[field], :value => field}}
    end
    result
  end
  
  def comments
    @comments
  end
  
  def tags
    @current_tags.split()
  end
  
  def tags=(tags)
    @current_tags = tags.to_a.join(' ')
  end
  
end