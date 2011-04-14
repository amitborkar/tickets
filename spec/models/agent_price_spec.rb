require File.dirname(__FILE__) + '/../spec_helper'

describe AgentPrice do

  before(:each) do
    Ticket.delete_all
    User.delete_all
    City.delete_all
    Spot.delete_all
  end

  it "should be valid" do
    AgentPrice.new.should be_valid
  end

  it "should return the rate for the season" do
    season1 = Factory.build(:season, :name => "season1")
    season2 = Factory.build(:season, :name => "season2")
    rate1 = Rate.new(:adult_price => 100, :child_price => 40, :season => season1)
    rate2 = Rate.new(:adult_price => 55, :child_price => 20, :season => season2)
    agent_price = Factory.build(:agent_price, :rates => [rate1, rate2])
    agent_price.public_rate_for("season1").adult_price.should == 100
  end

end
