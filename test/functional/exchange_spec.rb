require "yaml"
require_relative "../test_helper"
require_relative "../../app/exchange/exchange"

module Bittracktor
  module MultiTicker
    describe Exchange do

      before do
        #VCR.insert_cassette('exchange_spec')

        pairs           = %w(ltc_usd ltc_eur)
        @exchange       = build(:exchange, platform_name: "btce", pairs: pairs)
        app_root        = Bittracktor::MultiTicker::Base.settings.root
        @btce_data      = YAML.load_file("#{app_root}/app/exchange/btce.yml")
        @bitstamp_data  = YAML.load_file("#{app_root}/app/exchange/bitstamp.yml")
      end

      after do
        #VCR.eject_cassette
      end

      describe " [FUNCTIONAL] New Exchange instance" do
        it "must return the instance class" do
          @exchange.class.must_equal(Bittracktor::MultiTicker::Exchange)
        end
      end

      describe " [FUNCTIONAL] 'BTC-e' Exchange yaml data" do
        it "must contain the key 'pairs'" do
          keys = @btce_data["api"]["request"].keys
          keys.must_include("pairs")
        end

        it "must contain at least 1 supported pair" do
          pairs = @btce_data["api"]["request"]["pairs"]
          comp  = Exchange::SUPPORTED_PAIRS <=> pairs
          comp.wont_be_nil
        end
      end

      describe " [FUNCTIONAL] 'Bitstamp' Exchange yaml data" do
        it "must contain the key 'pairs'" do
          keys = @bitstamp_data["api"]["request"].keys
          keys.must_include("pairs")
        end

        it "must contain at least 1 supported pair" do
          pairs = @btce_data["api"]["request"]["pairs"]
          comp  = Exchange::SUPPORTED_PAIRS <=> pairs
          comp.wont_be_nil
        end
      end

    end
  end
end
