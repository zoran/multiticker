require_relative "../test_helper"

FactoryGirl.define do
  factory :ticker, class: "Bittracktor::MultiTicker::Ticker" do
    initialize_with { new(url: url, interval: interval) }
  end
end
