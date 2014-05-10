require_relative "../test_helper"
require_relative "../../app/receiver"

FactoryGirl.define do
  factory :receiver, class: "Bittracktor::MultiTicker::Receiver" do
    initialize_with { new() }
  end
end
