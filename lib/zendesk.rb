# Zendesk
require 'rubygems'
require 'active_support'
require 'rest_client'
require 'yaml'

module Zendesk
  
  class ConfigurationNotFound < NameError;
  end
  
  
  ZENDESK_ROOT          = File.expand_path((defined?(Rails) && Rails.root.to_s.length > 0) ? Rails.root : ".") unless defined?(ZENDESK_ROOT)
  DEFAULT_CONFIG_PATH   = File.join(ZENDESK_ROOT, 'config', 'zendesk.yml')

  def self.load_configuration(config_path)
    exists = config_path && File.exists?(config_path)
    raise ConfigurationNotFound, "could not find the \"#{config_path}\" configuration file" unless exists
    YAML.load_file(config_path)
  end

  def self.config
    @configuration ||= load_configuration(DEFAULT_CONFIG_PATH)
  end
  
  def self.resource
    @resource ||= RestClient::Resource.new config['host'], :user => config['user'], :password => config['password'], :timeout => 20, :open_timeout => 1
  end
  
  autoload :Resource, File.dirname(__FILE__) + '/zendesk/resource.rb'
  autoload :Comment, File.dirname(__FILE__) + '/zendesk/comment.rb'
  autoload :Ticket, File.dirname(__FILE__) + '/zendesk/ticket.rb'
  autoload :User, File.dirname(__FILE__) + '/zendesk/user.rb'
  
  autoload :Constants, File.dirname(__FILE__) + '/zendesk/lib/constants.rb'
  autoload :RestObject, File.dirname(__FILE__) + '/zendesk/lib/rest_object.rb'
  autoload :Properties, File.dirname(__FILE__) + '/zendesk/lib/properties.rb'
end