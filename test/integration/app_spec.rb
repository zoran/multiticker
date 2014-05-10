require "yaml"
require_relative "../test_helper"
require_relative "../../app/receiver"
require_relative "../../app/exchange/exchange"

module Bittracktor
  module MultiTicker
    describe Exchange do

      before do
        @btce           = build(:exchange, platform_name: "btce", pairs: ["ltc_usd", "btc_usd"])
        @bitstamp       = build(:exchange, platform_name: "bitstamp", pairs: ["btc_usd"])
        @pair           = build(:pair)
        app_root        = Bittracktor::MultiTicker::Base.settings.root
        @btce_data      = YAML.load_file("#{app_root}/app/exchange/btce.yml")
        @bitstamp_data  = YAML.load_file("#{app_root}/app/exchange/bitstamp.yml")
        @receiver       = Receiver.new
      end

      describe " [INTEGRATION] Supported 'BTC-e' Exchange pairs" do
        it "must be available as a method in BTC-e Pair" do
          @btce_data["api"]["request"]["pairs"].each do |pair|
            @pair.respond_to?(pair).must_be :==, true
          end
        end
      end

      describe " [INTEGRATION] Supported 'Bitstamp' Exchange pairs" do
        it "must be available as a method in Bitstamp Pair" do
          if @bitstamp_data["api"]["request"]["pairs"]
            @bitstamp_data["api"]["request"]["pairs"].each do |pair|
              @pair.respond_to?(pair).must_be :==, true
            end
          end
        end
      end

      describe " [INTEGRATION] start multiple tickers" do
        it "must return ticker data" do
          @bitstamp.ticker.start
          @btce.ticker.start

          #VCR.use_cassette('bitstamp-btce', allow_playback_repeats: true, record: :once) do
            sleep 2
            bitstamp_thr = Thread.new { @receiver.listen('bitstamp').must_match /volume/ }
            btce_thr = Thread.new { @receiver.listen('btce').must_match /ltc_usd/ }
            sleep 2
          #end

          bitstamp_thr.kill
          @bitstamp.ticker.stop

          btce_thr.kill
          @btce.ticker.stop
        end
      end

    end
  end
end
