# Zendesk
require 'rubygems'
require 'active_support'
module Zendesk
  autoload :Resource, File.dirname(__FILE__) + '/zendesk/resource.rb'  
  autoload :Ticket, File.dirname(__FILE__) + '/zendesk/ticket.rb'
  autoload :TicketConstants, File.dirname(__FILE__) + '/zendesk/ticket_constants.rb'
end