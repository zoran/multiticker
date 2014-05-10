require_relative "../test_helper"
require_relative "../../app/ticker/ticker"
require_relative "../../app/receiver"

module Bittracktor
  module MultiTicker
    class TestTicker < Minitest::Test

      def setup
        #VCR.insert_cassette('ticker_test')

        url       = "https://btc-e.com/api/3/ticker/ltc_usd?ignore_invalid=0" 
        @ticker   = build(:ticker, url: url, interval: 2)
        @receiver = Receiver.new
      end

      def teardown
        #VCR.eject_cassette
      end

      def test_start
        @ticker.start
        thr = Thread.new { @receiver.listen("btce").must_match /last/ }
        thr.kill
      end

      def test_stop
        @ticker.start
        @ticker.stop
      end

      def test_self_all
        Bittracktor::MultiTicker::Ticker.all.
          any? { |e| e.object_id == @ticker.object_id }.
          must_equal true
      end

    end
  end
end
