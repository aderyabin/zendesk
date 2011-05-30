# Zendesk
require 'rubygems'
require 'rest_client'
require 'yaml'
require 'rexml/document'

module Zendesk

  class ConfigurationNotFound < NameError;
  end


  ZENDESK_ROOT = File.expand_path((defined?(Rails) && Rails.root.to_s.length > 0) ? Rails.root : ".") unless defined?(ZENDESK_ROOT)
  DEFAULT_CONFIG_PATH = File.join(ZENDESK_ROOT, 'config', 'zendesk.yml')

  def self.load_configuration(config_path)
    exists = config_path && File.exists?(config_path)
    raise ConfigurationNotFound, "could not find the \"#{config_path}\" configuration file" unless exists
    YAML.load_file(config_path)
  end

  def self.config
    @configuration ||= load_configuration(DEFAULT_CONFIG_PATH)
  end

  def self.resource
    @resource ||= RestClient::Resource.new "http://#{config['sitename']}.zendesk.com/", :user => config['user'], :password => config['password'], :timeout => 20, :open_timeout => 1
  end
  
  def self.push(url, method, data = nil, on_behalf_of = nil)
    content_type = { :content_type => 'application/xml'}
    content_type.merge!({ 'X-On-Behalf-Of' => on_behalf_of }) if on_behalf_of
    if data
      Zendesk.resource[url].send method.to_sym, data, content_type
    else
      Zendesk.resource[url].send method.to_sym, content_type
    end
  end

  def self.xml_in(xml_data)
    xml_elements_to_hash REXML::Document.new(xml_data).root
  end

  def self.xml_elements_to_hash(element)
    value = element.text
    value = case element.attributes['type']
    when 'integer'
      value.to_i
    when 'datetime'
      DateTime.parse(element.text)
    else
      element.text
    end if value

    if element.elements.count > 0
      if element.attributes['type'] == 'array'
        value = element.elements.map{|el| xml_elements_to_hash(el) }
      else
        value = {}
        element.elements.each{|el| value.merge! xml_elements_to_hash(el) }
      end      
    end
    { element.name.gsub('-', '_').to_sym => value }      
  end

  def self.xml_out(hash)
    doc = REXML::Document.new 
    doc.add_element hash_elements_to_xml(hash.keys[0], hash.values[0])
    doc.to_s
  end  
  
  def self.hash_elements_to_xml(key, value)
    element = REXML::Element.new(key.to_s.gsub('_', '-'))
    if value.is_a?(Array)
      element.attributes['type'] = 'array'
      value.each{ |val| element.add_element hash_elements_to_xml(val.keys[0], val.values[0]) }
    elsif value.is_a?(Hash)
      value.each_pair{ |key, v| element.add_element hash_elements_to_xml(key, v) }
    else
      element.text = value
    end
    element
  end



  autoload :Resource, File.dirname(__FILE__) + '/zendesk/resource.rb'
  autoload :Comment, File.dirname(__FILE__) + '/zendesk/comment.rb'
  autoload :Ticket, File.dirname(__FILE__) + '/zendesk/ticket.rb'
  autoload :User, File.dirname(__FILE__) + '/zendesk/user.rb'

  autoload :Constants, File.dirname(__FILE__) + '/zendesk/lib/constants.rb'
  autoload :RestObject, File.dirname(__FILE__) + '/zendesk/lib/rest_object.rb'
  autoload :Properties, File.dirname(__FILE__) + '/zendesk/lib/properties.rb'
end