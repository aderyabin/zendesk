require 'rest_client'
class Zendesk::Resource
  include ActiveSupport::Callbacks
  
  define_callbacks :before_save, :after_save

  CONFIG = YAML.load_file(ENV['CONFIG'] || 'config.yml')
  RESOURCE = RestClient::Resource.new CONFIG['host'], :user => CONFIG['user'], :password => CONFIG['password'], :timeout => 20, :open_timeout => 1

  @@attributes = {}
  @@attribute_methods = ()

  def initialize(attributes = {})
    attr_keys = CONFIG[self.class.to_s.demodulize.downcase]
    
    @fields = {}
    attr_keys.try(:keys).each do |attr_name|
      @fields[attr_name.to_sym]  = attr_keys[attr_name]
    end
    
    @attributes = {}
    @@attributes.keys.each do |attr_name|
      @attributes[attr_name.to_sym]  = attributes[attr_name.to_sym] || attributes[@@attributes[attr_name.to_sym]]
    end
    
    @@attribute_methods.each do |name|
      self.class.send(:define_method, "#{name}=".to_sym) { |val| @attributes[name.to_sym] = val }
      self.class.send(:define_method, name.to_sym) { instance_variable_get("@attributes")[name.to_sym] }
    end
  end
  
  def self.find(id)
    RESOURCE["#{self.to_s.demodulize.downcase.pluralize}/#{id}.json"].get
  end
    
  def load_data(json)
    data  =JSON(json)
  end
  # def save
  #   run_callbacks(:before_save)
  #   super
  #   run_callbacks(:after_save)
  # end
end