require "yaml"
require_relative "../../config/base"
require_relative "../ticker/ticker"
require_relative "../pair"

module Bittracktor
  module MultiTicker
    class Exchange

      attr_reader :platform_name, :properties, :ticker, :pairs

      SUPPORTED_PAIRS ||= %w(ltc_usd ltc_eur btc_usd btc_eur)

      def initialize(platform_name: nil, pairs: nil)
        @pairs          = pairs
        @platform_name  = platform_name
        @properties     = get_properties(platform_name)
        valid_pairs     = get_valid_pairs(pairs, @properties)
        ticker_url      = get_ticker_url(platform_name, valid_pairs)
        @ticker         = create_ticker(ticker_url, get_interval)
      end

      class << self
        def all
          ObjectSpace.each_object(self).to_a
        end

        def instance_with_pairs_exist?(pairs)
          Exchange.all.collect { |e| pairs && e.pairs == @pairs }.size > 1
        end
      end

    private

      def create_ticker(ticker_url, interval)
        ticker = Ticker.new(
          url: ticker_url,
          interval: interval,
          platform_name: @platform_name
        )
      end

      def get_interval
        @properties["api"]["request"]["interval"]
      end

      def get_ticker_url(platform_name, valid_pairs)
        case platform_name
        when "bitstamp"
          @properties["api"]["request"]["url"]
        when "btce"
          part_1 = @properties["api"]["request"]["url"]
          part_2 = valid_pairs.join("-")
          part_3 = @properties["api"]["request"]["options"]

          [part_1, part_2, part_3].join
        else
          raise "Exchange platform '#{platform_name}' is not supported." 
        end
      end

      # Check if pairs are supported by this class and exchange
      def get_valid_pairs(pairs, properties)
        if pairs && pairs.size > 0
          # Check pairs supported by the app
          comp = pairs - SUPPORTED_PAIRS
          raise "\n\nPairs '#{comp.join(', ')}' are not supported by the application\n\n" unless comp && comp.empty? 

          if properties["api"]["request"]["pairs"]
            # Check pairs supported by the exchange platform
            comp = pairs - properties["api"]["request"]["pairs"]
            exchange_name = properties["name"]["long"]
            raise "\n\nPairs '#{comp.join(', ')}' are not supported by the exchange '#{exchange_name}'\n\n" unless comp && comp.empty? 
          end

          pairs # Requested pairs are obviously valid, return them
        else
          raise "\n\nArgument pairs must not be nil"
        end
      end

      def get_properties(platform_name)
        root = Bittracktor::MultiTicker::Base.settings.root
        YAML.load_file("#{root}/app/exchange/#{platform_name}.yml")
      end

    end
  end
end
