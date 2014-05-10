require_relative "../test_helper"
require_relative "../../app/pair"

module Bittracktor
  module MultiTicker
    class TestPair < Minitest::Test

      def setup
        @pair = build(:pair)
      end

      def test_ltc_usd
        resp = { long: "Litecoin/US Dollar", short: "LTC/USD", sign: "Ł/$", intern: "ltc_usd" }
        @pair.ltc_usd.must_equal(resp)
      end

      def test_ltc_eur
        resp = { long: "Litecoin/Euro",      short: "LTC/EUR", sign: "Ł/€", intern: "ltc_eur" }
        @pair.ltc_eur.must_equal(resp)
      end

      def test_btc_usd
        resp = { long: "Bitcoin/US Dollar",  short: "BTC/USD", sign: "฿/$", intern: "btc_usd" }
        @pair.btc_usd.must_equal(resp)
      end

      def test_btc_eur
        resp = { long: "Bitcoin/Euro",       short: "BTC/EUR", sign: "฿/€", intern: "btc_eur" }
        @pair.btc_eur.must_equal(resp)
      end

    end
  end
end
