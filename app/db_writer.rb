require "json"
require "sidekiq"

module Bittracktor
  module MultiTicker
    class DbWriter

      class << self

        include Sidekiq::Worker

        def create(platform_model, platform_name, data)
          # API response is categorized by pair(s):
          # '{"ltc_usd":{"high":20.25,"low":17.05,"avg":18.65,"vol":12204342.95332,"vol_cur":656049.029,"last":19.299,"buy":19.2998,"sell":19.299,"updated":1395178549},"ltc_eur":{"high":14.6,"low":12.445,"avg":13.5225,"vol":128904.23216,"vol_cur":9489.85753,"last":14.133,"buy":14.124,"sell":13.958,"updated":1395178549}}'
          if Exchange::SUPPORTED_PAIRS.include?(data.first.first)
            data.keys.each do |pair|
              write_data(platform_model, platform_name, data[pair], pair)
            end
          else
            # Exchange supports only 1 pair. API response is not categorized:
            # '{"high": "627.79", "last": "616.90", "timestamp": "1395178530", "bid": "615.49", "vwap": "611.35", "volume": "15831.49387408", "low": "591.13", "ask": "616.90"}'
            pair = properties(platform_name)["api"]["request"]["pairs"].first
            write_data(platform_model, platform_name, data, pair)
          end
        end

      private

        def write_data(platform_model, platform_name, data, pair)
          props = properties(platform_name)["response_attr_map"]

          platform_model.create(
              exchange_name:  platform_name,
                       pair:  pair,
                  timestamp:  Time.at(data[props["timestamp"]].to_i).utc,
                       high:  data[props["high"]].to_f,
                        low:  data[props["low"]].to_f,
                        avg:  data[props["avg"]].to_f,
                     volume:  data[props["volume"]].to_f,
                    vol_cur:  data[props["vol_cur"]].to_f,
                       last:  data[props["last"]].to_f,
                        bid:  data[props["bid"]].to_f,
                       vwap:  data[props["vwap"]].to_f,
                        ask:  data[props["ask"]].to_f
          )
        end

        def properties(platform_name)
          YAML.load_file(File.join(__dir__, "../app/exchange", "#{platform_name}.yml"))
        end

      end
    end
  end
end
