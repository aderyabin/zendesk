class Zendesk::Comment < Zendesk::Resource
  
  def initialize(value, is_public = true)
    @value = value
    @is_public = is_public
  end
end