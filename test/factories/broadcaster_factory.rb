require_relative "../test_helper"
require_relative "../../app/broadcaster"

FactoryGirl.define do
  factory :broadcaster, class: "Bittracktor::MultiTicker::Broadcaster" do
    initialize_with { new() }
  end
end
