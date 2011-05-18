class Zendesk::User < Zendesk::Resource
  include Zendesk::RestObject
  
  datetimes :created_at, :updated_at
  properties :restriction
  attributes :name, :is_active, :is_verified, :locale_id, :time_zone, :details, :last_login, :notes, :external_id, :phone, :uses_12_hour_clock 
  protected_attributes :id, :email, :photo_url


  def initialize(attrs = {})
    @email = attrs[:email] || attrs['email']
    super
  end
  def to_xml
    result = {}
    attributes.each{|attr| result[attr] = instance_variable_get(:"@#{attr.to_s}") }
    result.to_xml(:skip_instruct => true, :root=>:user)
  end
end