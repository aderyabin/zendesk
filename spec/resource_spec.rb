require File.dirname(__FILE__) + '/spec_helper.rb'
require File.dirname(__FILE__) + '/../lib/zendesk'

describe "Resource" do
  it "should return true on check access if authenticated successfully" do
    Zendesk::Resource.check_access.should be_true
  end
end