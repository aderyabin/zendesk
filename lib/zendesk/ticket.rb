class Zendesk::Ticket < Zendesk::Resource


  attr_reader :nice_id, :created_at, :updated_at, :priority_id, :status_id, :via_id, :ticket_type_id, :current_tags, :created_at, :updated_at

  attr_accessor :fields, :subject, :description, :status, :assignee_id, :requester_name, :requester_email
  
  alias_attribute :id, :nice_id
  alias_attribute :set_tags, :current_tags
  
  STATUSES = { 0 => :new, 1 => :open, 2 => :pending, 3 => :solved, 4 => :closed }
  TICKET_TYPES = { 0 => :no_type_set, 1 => :question, 2 => :incident, 3 => :problem, 4 => :task }
  PRIORITIES = { 0 => :no_priority_set, 1=>:low, 2 => :normal, 3 => :high, 4 => :urgent }
  VIA_TYPES = { 0 => :web_form, 4 => :mail, 5 => :web_service, 16 => :get_satisfaction, 17 => :dropbox, 19 => :ticket_merge, 21 => :recovered_from_suspended_tickets, 23 => :twitter_favorite, 24 => :forum_topic, 26 => :twitter_direct_message, 27 => :closed_ticket, 29 => :chat , 30 => :twitter_public_mention }
  
  def initialize(attributes = {})
    
    @comments = []
    
    attr_keys = CONFIG[self.class.to_s.demodulize.downcase]
    @field_ids = {}
    field_names = attr_keys.try(:keys)
    unless field_names.blank?
      field_names = field_names.map(&:to_sym)
      attr_keys.try(:keys).each do |attr_name|
        @field_ids[attr_name.to_sym]  = attr_keys[attr_name]
      end
      @fields = Struct.new(*field_names).new
    end
    super
  end
  
  def save
    # RESOURCE["#{self.class.to_s.demodulize.downcase.pluralize}/#{id}.json"].put({:comment => {:is_public => true, :value => 'what da fuck men23'}})
    if self.id
      RESOURCE["#{self.class.to_s.demodulize.downcase.pluralize}/#{id}.json"].put self.to_json
    else
      RESOURCE["#{self.class.to_s.demodulize.downcase.pluralize}.json"].post self.to_json
    end
  end
  
  def to_json
    result = { :ticket => {} }
    [:subject, :description, :set_tags, :requester_name, :requester_email].each do |obj|
      result[:ticket][obj.to_s.downcase] = try(obj)
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
  
  def status
    STATUSES[@status_id.to_i]
  end
    
  def status=(status)
    @status_id = STATUSES.key(status)
  end
  
  def via
    VIA_TYPES[@via_id.to_i]
  end
  
  def via=(via)
    @via_id = VIA_TYPES.key(via)
  end
  
  def priority
    PRIORITIES[@priority.to_i]
  end
  
  def priority=(priority)
    @priority_id = PRIORITIES.key(priority)
  end
  
  def ticket_type
    TICKET_TYPES[@ticket_type_id.to_i]
  end
  
  def ticket_type=(ticket_type)
    @ticket_type_id = TICKET_TYPES.key(ticket_type)
  end
  
  def created_at
    DateTime.parse @created_at
  end
  
  def updated_at
    DateTime.parse @updated_at
  end
end