# Zendesk
require 'rubygems'
require 'active_support'
module Zendesk
  autoload :Resource, File.dirname(__FILE__) + '/zendesk/resource.rb'
  autoload :Comment, File.dirname(__FILE__) + '/zendesk/comment.rb'
  autoload :Ticket, File.dirname(__FILE__) + '/zendesk/ticket.rb'
  autoload :Constants, File.dirname(__FILE__) + '/zendesk/constants.rb'
  autoload :Properties, File.dirname(__FILE__) + '/zendesk/properties.rb'
end