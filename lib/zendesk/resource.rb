require 'rest_client'
class Zendesk::Resource
  include ActiveSupport::Callbacks


  CONFIG = YAML.load_file(ENV['CONFIG'] || 'config.yml')
  RESOURCE = RestClient::Resource.new CONFIG['host'], :user => CONFIG['user'], :password => CONFIG['password'], :timeout => 20, :open_timeout => 1

  attr_reader :data, :attributes, :protected_attributes

  def initialize(attributes = {})
    load_accessors(attributes)
  end

  def self.find(id)
    begin
      data = load_data(RESOURCE["#{self.to_s.demodulize.downcase.pluralize}/#{id}.json"].get)
      new_object = self.new(data)
      new_object.load_protected_attributes(data)
      new_object
    rescue
      nil
    end
  end


  def self.attr_accessor(*vars)
    @attributes ||= []
    @attributes.concat vars
    super(*vars)
  end

  def self.attr_reader(*vars)
    @protected_attributes ||= []
    @protected_attributes.concat vars
    super(*vars)
  end
  
  
  def self.attributes
    @attributes
  end
  
  def attributes
    self.class.attributes
  end

  def self.protected_attributes
    @protected_attributes
  end

  
  def protected_attributes
    self.class.protected_attributes
  end


  def self.load_data(json_data)
    puts JSON(json_data).inspect
    JSON(json_data)
  end

  def load_accessors(attrs = {})
    puts attrs.inspect
    attributes.each do |attr|
      instance_variable_set("@#{attr.to_s}", attrs[attr.to_sym])
    end
  end

  def load_protected_attributes(attrs = {})
    protected_attributes.each do |attr|
      instance_variable_set("@#{attr.to_s}", attrs[attr.to_sym])
    end
  end

end