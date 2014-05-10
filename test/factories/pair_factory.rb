require_relative "../test_helper"

FactoryGirl.define do
  factory :pair, class: "Bittracktor::MultiTicker::Pair" do
    #initialize_with { new(long_name, api_request_url, api_interval) }
  end
end