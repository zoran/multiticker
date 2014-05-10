#
# This Receiver is used only for testing purposes
#
require 'redis'

module Bittracktor
  module MultiTicker
    class Receiver

      def initialize
        @station = redis_instance
      end

      def listen(channel)
        #clean_up(channel) # rpush is not used

        @station.subscribe(channel) do |on|
          on.message do |channel, message|
            puts message
          end
        end
      end

    private

      def clean_up(channel)
        until (msg = @station.lpop(channel)) == nil
          puts msg
        end
      end

      # test and development connects to local Redis server
      def redis_instance
        if %w(staging production).include?(ENV['RACK_ENV'])
          Redis.connect(
            url: 'redis://multiticker.botradex.com:6380/',
            password: ENV['MULTITICKER_REDIS_PASSWORD']
          )
        else
          Redis.new
        end
      end

    end
  end
end
