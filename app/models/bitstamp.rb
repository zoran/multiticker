module Bittracktor
  module MultiTicker
    class Bitstamp < Sequel::Model(:bitstamp)

      plugin :validation_helpers

      set_allowed_columns :exchange_name, :timestamp, :pair,
          :high, :low, :avg, :volume, :vol_cur, :last, :bid, :ask, :timestamp, :vwap

      def before_create
        self.year       = Time.at(timestamp).year.to_i if timestamp
        self.created_at = Time.now.utc

        super
      end

    private

      def validate
        super
        validates_presence :exchange_name
      end

    end
  end
end

