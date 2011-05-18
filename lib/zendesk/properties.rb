module Zendesk::Properties
  module ClassMethods
    
    mattr_accessor :_attributes, :_protected_attributes, :_properties, :_datetimes
    
    @@_attributes = []
    @@_protected_attributes = []
    @@_properties = []
    @@_datetimes = []
    
    def attributes(*vars)
      @@_attributes.concat vars
      attr_accessor *vars
    end
    
    def protected_attributes(*vars)
      @@_protected_attributes.concat vars
      attr_reader *vars
    end
    
    def datetimes(*vars)
      protected_attributes *vars
      
      vars.each do |mn|
        method_name = mn.to_s
        class_eval <<-END
          def #{method_name}
            DateTime.parse @#{method_name}
          end
        END
      end
    end
    
    def properties(*vars)
      @@_properties.concat vars
      attr_accessor *vars

      vars.each do |property|
        attributes "#{property.to_s}_id".to_sym
        method_name = property.to_s
        class_eval <<-END
        def #{method_name}
          #{method_name.upcase}[@#{method_name}_id.to_i]
        end
        END

        class_eval <<-END
        def #{method_name}=(value)
          @#{method_name}_id = #{method_name.upcase}.index(value)
        end
        END
      end
    end
  end
  
  module InstanceMethods
    def attributes
      self.class._attributes
    end
    
    def properties
      self.class._properties
    end
    
    def protected_attributes
      self.class._protected_attributes
    end
    
    def load_attributes(attrs = {})
      attributes.each do |attr|
        if val = (attrs[attr.to_s] || attrs[attr.to_sym])
          instance_variable_set :"@#{attr.to_s}", val
        end
      end
    end

    def load_protected_attributes(attrs = {})
      protected_attributes.each do |attr|
        if val = (attrs[attr.to_s] || attrs[attr.to_sym])
          instance_variable_set :"@#{attr.to_s}", val
        end
      end
    end
    
    
    def load_properties(attrs = {})
      properties.each do |mn|
        method_name = mn.to_s
        if val = (attrs[method_name] || attrs[method_name.to_sym])
          send(:"#{method_name}=", val)
        end
      end
    end
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end