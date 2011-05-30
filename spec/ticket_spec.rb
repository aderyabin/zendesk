require File.dirname(__FILE__) + '/spec_helper.rb'
require File.dirname(__FILE__) + '/../lib/zendesk'

describe "Ticket" do
  it "should create class instance" do
    Zendesk::Ticket.new.class.should == Zendesk::Ticket
  end
  
  it 'should parse params on initialize' do
    description = 'ticket description'
    ticket = Zendesk::Ticket.new( 'description' => description )
    ticket.description.should == description
  end
  
  it 'should parse fields on initialize' do
    city = 'New York'
    ticket = Zendesk::Ticket.new( :city => city )
    ticket.city.should == city
  end
  
  it 'should parse properties on initialize' do
    ticket = Zendesk::Ticket.new( :ticket_type => :problem )
    ticket.ticket_type.should == :problem
    ticket.ticket_type_id.should  == 3
  end
  
  it 'should convert to xml' do
    ticket = Zendesk::Ticket.new( :description => 'ticket_description', :tags => 'one_two' )
    ticket.to_xml.gsub(/<ticket>|<description>ticket_description|<\/description>|<set-tags>one_two<\/set-tags>|<\/ticket>/, '').should == ''
  end
  
  it 'should create new ticket with description' do
    description = 'Email form is not correct'
    ticket = Zendesk::Ticket.new( :description => description )
    ticket.save.should be_true
    
    zendesk_responce = Zendesk.push"tickets/#{ticket.id}", :get
    zendesk_responce.is_a?(String).should be_true
    zendesk_responce.should include("<description>#{description}</description>")
  end
  
  it 'should reload ticket on success save' do
    description = 'Email form is not correct'
    ticket = Zendesk::Ticket.new( :description => description )
    ticket.save.should be_true
    ticket.id.should_not == nil
  end
  
  it 'should set tags as params and as attrubute' do
    ticket = Zendesk::Ticket.new( :tags => ['one', 'two', 'four'] )
    ticket.tags.should == ['one', 'two', 'four']
    ticket.to_xml.should include('<set-tags>one two four</set-tags>')
    
    ticket.tags = 'a b c'
    ticket.tags.should == %w(a b c)
    ticket.to_xml.should include('<set-tags>a b c</set-tags>')
  end
  
  it 'should set on_behalf_of attribute' do
    ticket = Zendesk::Ticket.create( :description => 'ticket', :on_behalf_of => 'manager@example.com' )
    ticket.requester.email.should == 'manager@example.com'
  end

  it 'should set on_behalf_of method' do
    ticket = Zendesk::Ticket.new( :description => 'ticket' )
    ticket.on_behalf_of = 'manager@example.com'
    ticket.save
    ticket.requester.email.should == 'manager@example.com'
  end
  
  it 'should set requester as attribute' do
    ticket = Zendesk::Ticket.create( :description => 'ticket', :requester_email => 'requester@example.com', :requester_name => 'Joe Doe' )
    ticket.requester.email.should == 'requester@example.com'
    ticket.requester.name.should == 'Joe Doe' 
  end
  
  it 'should set requester as methods' do
    ticket = Zendesk::Ticket.new( :description => 'ticket')
    ticket.requester_email = 'requester@example.com'
    ticket.requester_name = 'Joe Doe'
    ticket.save
    ticket.requester.email.should == 'requester@example.com'
    ticket.requester.name.should == 'Joe Doe' 
  end
  
end