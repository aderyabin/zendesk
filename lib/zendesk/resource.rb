require 'rest_client'
require 'yaml'
class Zendesk::Resource
  include ActiveSupport::Callbacks


  # TODO: Make load file as optional
  CONFIG = YAML.load_file('zendesk.yml')
  RESOURCE = RestClient::Resource.new CONFIG['host'], :user => CONFIG['user'], :password => CONFIG['password'], :timeout => 20, :open_timeout => 1

  @@attributes = []
  @@protected_attributes = []
  @@properties = []

  attr_reader :attributes, :protected_attributes

  def initialize(attributes = {})
  end

  def self.find(id)
    begin
      self.new().load(id)
      rescue
        nil
    end
  end

  def load(id)
    begin
      data = load_data(RESOURCE["#{self.class.to_s.demodulize.downcase.pluralize}/#{id}.json"].get)
      puts data.inspect
      load_attributes(data)
      load_protected_attributes(data)
      load_fields(data)
      self
    rescue
      nil
    end
  end

  def self.attributes(*vars)
    @@attributes.concat vars
    attr_accessor *vars
  end

  def self.properties(*vars)
    @@properties.concat vars
    attr_accessor *vars
  end


  def self.protected_attributes(*vars)
    @@protected_attributes.concat vars
    attr_reader *vars
  end

  def load_data(json_data)
    JSON(json_data)
  end
  
  def load_attributes(attrs = {})
    attributes.each do |attr|
      if val = (attrs[attr.to_s] || attrs[attr.to_sym])
        instance_variable_set :"@#{attr.to_s}", val
      end
    end
  end
  
  def load_protected_attributes(attrs = {})
    protected_attributes.each do |attr|
      if val = (attrs[attr.to_s] || attrs[attr.to_sym])
        instance_variable_set :"@#{attr.to_s}", val
      end
    end
  end
  
  def load_fields(data)
  end
end