require File.dirname(__FILE__) + '/spec_helper.rb'
require File.dirname(__FILE__) + '/../lib/zendesk'

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           describe "Ticket" do
  it "should create class instance" do
    Zendesk::Ticket.new.class.should == Zendesk::Ticket
  end
  
  it 'should parse params on initialize' do
    description = 'ticket description'
    ticket = Zendesk::Ticket.new( :description => description )
    ticket.description.should == description
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
    ticket = Zendesk::Ticket.new( :description => 'ticket_description', :tags => 'one two three' )
    ticket.to_xml.should == "<ticket><description>ticket_description</description><set-tags>one two three</set_tags></ticket>"
  end
  
end