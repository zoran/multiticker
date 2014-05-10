require 'rack'
require_relative 'config/base'
require_relative 'app/exchange/exchange'

module Bittracktor
  module MultiTicker
    class App < Base

      def initialize
        start_btce
        start_bitstamp
      end

    private

      def start_btce
        btce = Bittracktor::MultiTicker::Exchange.new(
          platform_name: 'btce',
          pairs: %w(ltc_usd ltc_eur btc_usd btc_eur)
        )
        btce.ticker.start
      end

      def start_bitstamp
        bitstamp = Bittracktor::MultiTicker::Exchange.new(
          platform_name: 'bitstamp',
          pairs: %w(btc_usd)
        )
        bitstamp.ticker.start
      end

    end
  end
end
