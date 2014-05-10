# encoding: UTF-8

module Bittracktor
  module MultiTicker
    class Pair

      attr_reader :ltc_usd, :ltc_eur, :btc_usd, :ltc_usd

      def initialize
        @ltc_usd = ltc_usd
        @ltc_eur = ltc_eur
        @btc_usd = btc_usd
        @btc_eur = btc_eur
      end

      def ltc_usd
        {
          long: "Litecoin/US Dollar",
         short: "LTC/USD",
          sign: "Ł/$",
        intern: "ltc_usd"
        }
      end

      def ltc_eur
        {
            long: "Litecoin/Euro",
           short: "LTC/EUR",
            sign: "Ł/€",
          intern: "ltc_eur"
        }
      end

      def btc_usd
        {
            long: "Bitcoin/US Dollar",
           short: "BTC/USD",
            sign: "฿/$",
          intern: "btc_usd"
        }
      end

      def btc_eur
        {
            long: "Bitcoin/Euro",
           short: "BTC/EUR",
            sign: "฿/€",
          intern: "btc_eur"
        }
      end

    end
  end
end
