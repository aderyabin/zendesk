class Zendesk::Ticket < Zendesk::Resource

  before_save :saving_message
  
  @@attributes = {:tags => :current_tags, :id => :nice_id}
  @@attribute_methods = %w(tags)
  
  def saving_message
    puts "saving..."
  end

  after_save do |object|
    puts "saved"
  end
  
  protected
  
  def load_attributes
    
  end
  
  
end