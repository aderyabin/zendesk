# Zendesk
require 'rubygems'
require 'active_support'
require 'rest_client'
require 'yaml'

module Zendesk
  
  CONFIG = YAML.load_file('zendesk.yml')
  RESOURCE = RestClient::Resource.new CONFIG['host'], :user => CONFIG['user'], :password => CONFIG['password'], :timeout => 20, :open_timeout => 1
  
  # TODO: Make load file as optional
  
  autoload :Resource, File.dirname(__FILE__) + '/zendesk/resource.rb'
  autoload :Comment, File.dirname(__FILE__) + '/zendesk/comment.rb'
  autoload :Ticket, File.dirname(__FILE__) + '/zendesk/ticket.rb'
  autoload :User, File.dirname(__FILE__) + '/zendesk/user.rb'
  
  autoload :Constants, File.dirname(__FILE__) + '/zendesk/lib/constants.rb'
  autoload :RestObject, File.dirname(__FILE__) + '/zendesk/lib/rest_object.rb'
  autoload :Properties, File.dirname(__FILE__) + '/zendesk/lib/properties.rb'
end