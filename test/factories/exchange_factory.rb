require_relative "../test_helper"

FactoryGirl.define do
  factory :exchange, class: "Bittracktor::MultiTicker::Exchange" do
    initialize_with { new(platform_name: platform_name, pairs: pairs) }
  end
end
