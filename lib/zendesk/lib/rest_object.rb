module Zendesk::RestObject
  module ClassMethods
    def create(attrs = {})
      instance = new(attrs)
      instance.save
      instance
    end

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
    def path
      self.class.to_s.demodulize.downcase.pluralize
    end
    
    def save
      begin
        response = if self.id
          Zendesk.resource["#{path}/#{id}.xml"].put self.to_xml, :content_type => 'application/xml'
        else  
          Zendesk.resource["#{path}.xml"].post self.to_xml, :content_type => 'application/xml'
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
        data = load_data(Zendesk.resource["#{path}/#{id}.xml"].get)[path.singularize]
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