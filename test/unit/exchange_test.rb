require_relative "../test_helper"
require_relative "../../app/exchange/exchange"

module Bittracktor
  module MultiTicker
    class TestExchange < Minitest::Test

      def setup
        #VCR.insert_cassette('exchange_test')

        btce_pairs         = %w(ltc_usd btc_usd)
        bitstamp_pairs     = %w(btc_usd)
        @exchange_btce     = build(:exchange, platform_name: "btce", pairs: btce_pairs)
        @exchange_bitstamp = build(:exchange, platform_name: "bitstamp", pairs: bitstamp_pairs)
      end

      def teardown
        #VCR.eject_cassette
      end

      def test_get_properties
        @exchange_btce.properties.must_be_kind_of(Hash)
      end

      def test_get_valid_pairs
        pairs           = %w(ltc_usd btc_usd)
        supported_pairs = Bittracktor::MultiTicker::Exchange::SUPPORTED_PAIRS
        properties      = @exchange_btce.properties

        @exchange_btce.
          send(:get_valid_pairs, pairs, properties).must_equal(pairs)

        proc { @exchange_btce.send(:get_valid_pairs, nil, properties) }.
            must_raise RuntimeError
      end

      def test_get_ticker_url
        # btce
        platform_name = "btce"
        pairs         = %w(ltc_usd btc_usd)
        eq_string     = "https://btc-e.com/api/3/ticker/#{pairs.join("-")}?ignore_invalid=0"
        @exchange_btce.
            send(:get_ticker_url, platform_name, pairs).
            must_equal(eq_string)

        # bitstamp
        platform_name = "bitstamp"
        eq_string     = "https://www.bitstamp.net/api/ticker/"
        @exchange_bitstamp.
            send(:get_ticker_url, platform_name, nil).
            must_equal(eq_string)

        proc { @exchange_btce.send(:get_ticker_url, "invalid_platform_name", Array.new) }.
            must_raise RuntimeError
      end

      def test_self_all
        Bittracktor::MultiTicker::Exchange.all.
          any? { |e| e.object_id == @exchange_btce.object_id }.
          must_equal true
      end

      def test_instance_with_pairs_exist?
        Bittracktor::MultiTicker::Exchange.instance_with_pairs_exist?("ltc_usd").
            must_equal true
      end

    end
  end
end
