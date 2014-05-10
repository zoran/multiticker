require_relative "../test_helper"
require_relative "../../app/ticker/ticker"

module Bittracktor
  module MultiTicker
    describe Ticker do

      before do
        #VCR.insert_cassette('ticker_spec')

        url     = "https://btc-e.com/api/3/ticker/ltc_usd-ltc_eur?ignore_invalid=0"
        @ticker = build(:ticker, url: url, interval: 2)
      end

      after do
        #VCR.eject_cassette
      end

      describe " [FUNCTIONAL] New Ticker instance" do
        it "must return the instance class" do
          @ticker.class.must_equal(Bittracktor::MultiTicker::Ticker)
        end
      end

    end
  end
end
