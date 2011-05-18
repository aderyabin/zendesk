require 'rest_client'
require 'yaml'
class Zendesk::Resource
  include ActiveSupport::Callbacks
  include Zendesk::Properties
  
  # TODO: Make load file as optional
  CONFIG = YAML.load_file('zendesk.yml')
  RESOURCE = RestClient::Resource.new CONFIG['host'], :user => CONFIG['user'], :password => CONFIG['password'], :timeout => 20, :open_timeout => 1

  def initialize(attributes = {})
  end
  
  def load_data(json_data)
    JSON(json_data)
  end

end