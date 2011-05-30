module Zendesk::RestObject
  module ClassMethods
    def find(id)
      begin
        new().load(id)
      rescue Exception => e
        puts e.message
        nil
      end
    end
  end

  module InstanceMethods
    def model_name
      self.class.to_s.gsub(/^.*::/, '').downcase
    end
    
    def on_behalf_of_header
      if on_behalf_of
        
      else
        nil
      end
    end
    
    def save
      begin
        response = if self.id
          Zendesk.push "#{model_name}s/#{id}.xml", 'put', self.to_xml, self.on_behalf_of
        else
          Zendesk.push "#{model_name}s.xml", 'post', self.to_xml, self.on_behalf_of
        end
        if (200..300).include?(response.headers[:status].to_i)
          load(id || response.headers[:location].scan(/\d+/).first.to_i)
          return true
        else
          return false
        end
      rescue Exception => e
        puts e.message
        return false
      end
    end

    def reload
      return false unless id
      begin
        load(id)
      rescue Exception => e
        puts e.message
        nil
      end
    end
    
    def load(id)
      begin
        data = load_data(Zendesk.push("#{model_name}s/#{id}.xml", 'get'))[model_name.to_sym]
        load_attributes(data)
        load_protected_attributes(data)
        load_field_entries(data) if respond_to?(:load_field_entries)
        load_comments(data) if respond_to?(:load_comments)
        self
      rescue Exception => e
        puts e.message
        nil
      end
    end
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end