# Zendesk
require 'rubygems'
require 'active_resource'

module Zendesk
  autoload :Resource, File.dirname(__FILE__) + '/zendesk/resource.rb'  
  autoload :Ticket, File.dirname(__FILE__) + '/zendesk/ticket.rb'
end