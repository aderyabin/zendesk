module Zendesk::TicketConstants
  STATUS = {
    0 => :new,
    1 => :open,
    2 => :pending,
    3 => :solved,
    4 => :closed 
  }

  TICKET_TYPE = { 
    0 => :no_type_set,
    1 => :question,
    2 => :incident,
    3 => :problem,
    4 => :task 
  }

  PRIORITY = { 
    0 => :no_priority_set,
    1=>:low,
    2 => :normal,
    3 => :high,
    4 => :urgent 
  }

  VIA = { 
    0 => :web_form,
    4 => :mail,
    5 => :web_service,
    16 => :get_satisfaction,
    17 => :dropbox,
    19 => :ticket_merge,
    21 => :recovered_from_suspended_tickets,
    23 => :twitter_favorite,
    24 => :forum_topic,
    26 => :twitter_direct_message,
    27 => :closed_ticket,
    29 => :chat,
    30 => :twitter_public_mention
  }
end